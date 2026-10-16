#!/usr/bin/env fish

# Interactive helper for this repository's NixOS flake:
#   1. rebuild a host (switch, build or dry-build)
#   2. collect garbage
#   3. add a new host (skeleton files + flake entry)
# Run it as your normal user; it calls sudo itself where needed and finds the repository from
# its own location.

set -g repo (git -C (dirname (realpath (status filename))) rev-parse --show-toplevel 2>/dev/null)
if test -z "$repo"
    echo "❌ Could not find the git repository this script lives in" >&2
    exit 1
end

set -g state_dir ~/.local/state/nixos_manager
set -q XDG_STATE_HOME; and set state_dir $XDG_STATE_HOME/nixos_manager
set -g current_system (uname -m)-linux
set -g flake_marker "# nixos_manager: new hosts are inserted above this line"
set -g flake_modules \
    "home-manager          Home Manager as a NixOS module (creates home.nix)" \
    "nur                   Nix User Repository (pkgs.nur)" \
    "nix-vscode-extension  overlay with VS Code extensions" \
    "vscode-server         VS Code remote server support"

# nix without the "Git tree is dirty" warning
function nixq
    nix --option warn-dirty false $argv
end

# Prompts store their result in a global variable instead of printing it, so they are called
# directly (never inside a command substitution) and the prompt stays visible.

# choose PROMPT [--default N] OPTION...  →  $choice, $choice_index
function choose
    set -l prompt $argv[1]
    set -l options $argv[2..]
    set -l default ""
    if test "$options[1]" = --default
        set default $options[2]
        set options $options[3..]
    end
    for i in (seq (count $options))
        echo "  $i) $options[$i]"
    end
    set -l hint ""
    test -n "$default"; and set hint " [$default]"
    while true
        read -l -P "$prompt$hint: " reply; or return 1
        test -z "$reply"; and set reply $default
        if string match -qr '^[0-9]+$' -- $reply; and test $reply -ge 1 -a $reply -le (count $options)
            set -g choice $options[$reply]
            set -g choice_index $reply
            return 0
        end
        echo "Please enter a number from 1 to "(count $options)"."
    end
end

# choose_many PROMPT OPTION...  →  $choices (may be empty)
function choose_many
    set -l prompt $argv[1]
    set -l options $argv[2..]
    for i in (seq (count $options))
        echo "  $i) $options[$i]"
    end
    while true
        read -l -P "$prompt (numbers separated by spaces, Enter for none): " reply; or return 1
        set -l picked
        set -l valid true
        for n in (string split -n ' ' -- $reply)
            if string match -qr '^[0-9]+$' -- $n; and test $n -ge 1 -a $n -le (count $options)
                contains -- $options[$n] $picked; or set -a picked $options[$n]
            else
                set valid false
            end
        end
        if $valid
            set -g choices $picked
            return 0
        end
        echo "Please enter numbers from 1 to "(count $options)"."
    end
end

# ask PROMPT [DEFAULT]  →  $answer
function ask --argument-names prompt default
    set -l hint ""
    test -n "$default"; and set hint " [$default]"
    read -l -P "$prompt$hint: " reply; or return 1
    test -z "$reply"; and set reply $default
    set -g answer $reply
    return 0 # `set` keeps the previous status, which is 1 whenever a reply was typed
end

# confirm PROMPT  →  status 0 for yes
function confirm --argument-names prompt
    read -l -P "$prompt [y/N]: " reply; or return 1
    string match -qir '^y(es)?$' -- $reply
end

function list_hosts
    nixq eval --raw "$repo#nixosConfigurations" --apply 'c: builtins.concatStringsSep "\n" (builtins.attrNames c)'
end

# NixOS release of a flake input, e.g. "26.11"
function input_release --argument-names input
    nixq eval --raw --impure --expr '(builtins.getFlake "'$repo'").inputs.'$input'.lib.trivial.release'
end

function store_usage
    set -l fields (df -h --output=used,avail /nix/store | tail -n1 | string split -n ' ')
    echo "$fields[1] used, $fields[2] free"
end

function rebuild_host
    set -l hosts (list_hosts)
    if test (count $hosts) -eq 0
        echo "❌ Could not evaluate the flake in $repo"
        return 1
    end
    set -l last (cat $state_dir/host 2>/dev/null)
    set -l default (contains -i -- "$last" $hosts; or contains -i -- (uname -n) $hosts)

    echo
    echo "Which host?"
    choose Host --default "$default" $hosts; or return
    set -l host $choice

    echo
    echo "What should nixos-rebuild do?"
    choose Action \
        "switch     build it and activate it on this machine now" \
        "build      only build it (leaves ./result in the repository)" \
        "dry-build  only show what would be built or downloaded"; or return
    set -l mode (string split -f1 ' ' -- $choice)

    if test $mode != dry-build
        echo "🔍 Checking $host…"
        set -l info (nixq eval --raw "$repo#nixosConfigurations.$host.config" \
            --apply 'c: c.nixpkgs.hostPlatform.system + " " + c.networking.hostName')
        or begin
            echo "❌ $host does not evaluate; run a dry-build to see the error"
            return 1
        end
        set info (string split ' ' -- $info)
        set -l host_system $info[1]
        set -l host_name $info[2]

        if test $host_system != $current_system; and not test -e /proc/sys/fs/binfmt_misc/$host_system
            echo "❌ $host is built for $host_system; this $current_system machine can't build it. Use dry-build instead."
            return 1
        end

        if test $mode = switch
            if test $host_system != $current_system
                echo "❌ $host is built for $host_system; this $current_system machine can't run it."
                return 1
            end
            if test "$host_name" != (uname -n)
                echo "ℹ️  $host sets the hostname '$host_name'; this machine is currently called '"(uname -n)"'."
            end
            if test "$host" != "$last"
                set -l last_label none
                test -n "$last"; and set last_label $last
                echo "⚠️  This tool has not switched this machine to $host before (last switch: $last_label)."
                echo "   Switching a machine to another machine's configuration can leave it unbootable."
                ask "Type '$host' to continue"; or return
                if test "$answer" != "$host"
                    echo "Cancelled."
                    return
                end
            else if not confirm "Switch this machine to $host?"
                echo "Cancelled."
                return
            end
        end
    end

    set -l cmd nixos-rebuild $mode --flake "$repo#$host"
    test $mode = switch; and set -p cmd sudo
    echo "▶ $cmd"
    pushd $repo
    $cmd
    set -l rc $status
    popd
    if test $rc -ne 0
        echo "❌ nixos-rebuild $mode failed (exit $rc)"
        return $rc
    end

    if test $mode = switch
        mkdir -p $state_dir
        echo $host >$state_dir/host
    end
    test $mode = build; and echo "   Built system: $repo/result"
    echo "✅ nixos-rebuild $mode for $host finished"
end

function collect_garbage
    echo
    echo "What should be deleted?"
    choose Choice \
        "generations older than N days, then unreferenced store paths" \
        "all old generations, then unreferenced store paths" \
        "only unreferenced store paths (keep every generation)"; or return
    set -l args
    switch $choice_index
        case 1
            ask "Keep generations from how many past days" 14; or return
            if not string match -qr '^[0-9]+$' -- $answer
                echo "❌ '$answer' is not a number of days"
                return 1
            end
            set args --delete-older-than {$answer}d
        case 2
            set args --delete-old
    end

    echo "💾 /nix/store before: "(store_usage)
    if not confirm "Run '"(string join ' ' -- nix-collect-garbage $args)"' for your user and for the system (sudo)?"
        echo "Cancelled."
        return
    end
    nix-collect-garbage $args; or return
    sudo nix-collect-garbage $args; or return
    echo "💾 /nix/store after: "(store_usage)

    if test (count $args) -gt 0
        echo "The boot menu keeps listing deleted generations until the next switch or boot."
        if confirm "Update the boot menu now?"
            sudo /run/current-system/bin/switch-to-configuration boot
        end
    end
    echo "✅ Garbage collection finished"
end

function add_host
    if not grep -qF -- "$flake_marker" $repo/flake.nix
        echo "❌ flake.nix no longer contains the line: $flake_marker"
        return 1
    end
    set -l hosts (list_hosts)

    echo
    ask "Name of the new host (lowercase letters, digits and dashes)"; or return
    set -l name $answer
    if not string match -qr '^[a-z][a-z0-9-]*$' -- $name
        echo "❌ '$name' is not a valid host name"
        return 1
    end
    if contains -- $name $hosts; or test -e $repo/hosts/$name
        echo "❌ A host called '$name' already exists"
        return 1
    end
    ask "One-line description for README.md (optional)"; or return
    set -l description $answer

    echo
    echo "Which architecture?"
    set -l systems x86_64-linux aarch64-linux
    choose Architecture --default (contains -i -- $current_system $systems; or echo 1) $systems; or return
    set -l system $choice

    echo
    echo "🔍 Reading the nixpkgs versions…"
    set -l unstable_release (input_release nixpkgs)
    set -l stable_release (input_release nixpkgs-stable)
    if test -z "$unstable_release" -o -z "$stable_release"
        echo "❌ Could not read the nixpkgs versions from the flake"
        return 1
    end
    echo "Which nixpkgs?"
    choose nixpkgs --default 1 \
        "unstable  nixpkgs $unstable_release, the same inputs as the desktop hosts" \
        "stable    nixpkgs $stable_release, the same inputs as nixos-oracle"; or return
    set -l channel (string split -f1 ' ' -- $choice)
    set -l release $unstable_release
    test $channel = stable; and set release $stable_release

    echo
    ask "Main user" $USER; or return
    set -l user $answer
    if not string match -qr '^[a-z_][a-z0-9_-]*$' -- $user
        echo "❌ '$user' is not a valid user name"
        return 1
    end
    ask "Time zone" (string replace -r '^.*/zoneinfo/' '' -- (readlink /etc/localtime)); or return
    set -l timezone $answer

    echo
    echo "Which flake modules should $name use?"
    choose_many Modules $flake_modules; or return
    set -l modules
    for entry in $choices
        set -a modules (string split -f1 ' ' -- $entry)
    end

    set -l hardware placeholder
    if test $system = $current_system
        echo
        if confirm "Will $name run on this machine? Then hardware-configuration.nix is generated from it"
            set hardware generated
        end
    end

    set -l header "NixOS configuration for $name"
    test -n "$description"; and set header "$header ($description)"
    echo
    echo "Summary:"
    echo "  host:      $name"
    echo "  system:    $system"
    echo "  nixpkgs:   $channel ($release)"
    echo "  user:      $user"
    echo "  time zone: $timezone"
    echo "  modules:   "(string join ', ' -- $modules; or echo none)
    echo "  hardware:  "(test $hardware = generated; and echo "generated from this machine"; or echo "placeholder, replace it on the target machine")
    if not confirm "Create it?"
        echo "Cancelled."
        return
    end

    set -l dir $repo/hosts/$name
    mkdir -p $dir; or return 1

    printf '%s\n' \
        "# $header" \
        '{ pkgs, ... }:' \
        '{' \
        '  imports = [ ./hardware-configuration.nix ];' \
        '' \
        '  boot.loader = {' \
        '    systemd-boot.enable = true;' \
        '    efi.canTouchEfiVariables = true;' \
        '  };' \
        '' \
        '  networking = {' \
        "    hostName = \"$name\";" \
        '    networkmanager.enable = true;' \
        '  };' \
        '' \
        "  time.timeZone = \"$timezone\";" \
        '  i18n.defaultLocale = "en_US.UTF-8";' \
        '' \
        "  # No password is set here: after installing, run `passwd $user` as root." \
        "  users.users.$user = {" \
        '    isNormalUser = true;' \
        '    extraGroups = [ "wheel" "networkmanager" ];' \
        '  };' \
        '' \
        '  nix.settings.experimental-features = [ "nix-command" "flakes" ];' \
        '' \
        '  environment.systemPackages = with pkgs; [' \
        '    git' \
        '    vim' \
        '  ];' \
        '' \
        '  # The NixOS release this host was first installed with. Never change it afterwards.' \
        "  system.stateVersion = \"$release\";" \
        '}' >$dir/configuration.nix

    if test $hardware = generated
        if not nixos-generate-config --show-hardware-config >$dir/hardware-configuration.nix
            echo "⚠️  nixos-generate-config failed; writing the placeholder instead"
            set hardware placeholder
        end
    end
    if test $hardware = placeholder
        printf '%s\n' \
            '# Placeholder that lets the flake evaluate. On the target machine, replace this file with the' \
            '# output of `nixos-generate-config --show-hardware-config`. The labels below match the' \
            '# partitioning example in the NixOS manual.' \
            '{ lib, ... }:' \
            '{' \
            '  fileSystems = {' \
            '    "/" = {' \
            '      device = "/dev/disk/by-label/nixos";' \
            '      fsType = "ext4";' \
            '    };' \
            '    "/boot" = {' \
            '      device = "/dev/disk/by-label/boot";' \
            '      fsType = "vfat";' \
            '      options = [ "fmask=0077" "dmask=0077" ];' \
            '    };' \
            '  };' \
            '' \
            "  nixpkgs.hostPlatform = lib.mkDefault \"$system\";" \
            '}' >$dir/hardware-configuration.nix
    end

    if contains home-manager $modules
        printf '%s\n' \
            "# Home Manager configuration for $user on $name" \
            '_:' \
            '{' \
            "  home.stateVersion = \"$release\";" \
            '  programs.home-manager.enable = true;' \
            '}' >$dir/home.nix
    end

    # Flake entry, inserted above the marker line
    set -l module_list "[ ]"
    test (count $modules) -gt 0; and set module_list "[ "(string join ' ' -- '"'$modules'"')" ]"
    set -l entry (mktemp)
    printf '%s\n' \
        "        $name = mkHost {" \
        "          host = \"$name\";" \
        "          system = \"$system\";" \
        "          channel = \"$channel\";" \
        "          user = \"$user\";" \
        "          modules = $module_list;" \
        '        };' \
        '' >$entry
    awk -v marker="$flake_marker" -v entry="$entry" '
        index($0, marker) { while ((getline line < entry) > 0) print line }
        { print }' $repo/flake.nix >$repo/flake.nix.tmp
    and mv $repo/flake.nix.tmp $repo/flake.nix
    or begin
        echo "❌ Could not update flake.nix"
        rm -f $entry $repo/flake.nix.tmp
        return 1
    end
    rm -f $entry

    # README.md: add the host after the last entry of the hosts/ tree
    set -l readme_line "│   ├── $name"
    test -n "$description"; and set readme_line "│   ├── "(string pad -r -w 22 -- $name)" # $description"
    awk -v entry="$readme_line" '
        { lines[NR] = $0 }
        /^├── programs\// && !hosts_end { hosts_end = NR }
        END {
            limit = hosts_end ? hosts_end : NR + 1
            for (i = 1; i < limit; i++) if (lines[i] ~ /^│   ├── /) last = i
            for (i = 1; i <= NR; i++) { print lines[i]; if (i == last) print entry }
            if (!last) exit 1
        }' $repo/README.md >$repo/README.md.tmp
    and mv $repo/README.md.tmp $repo/README.md
    or begin
        rm -f $repo/README.md.tmp
        echo "⚠️  Could not find the hosts/ tree in README.md; add $name there yourself"
    end

    # Flakes only see files git knows about
    set -l files $dir/*.nix
    git -C $repo add --intent-to-add -- $files

    pushd $repo
    echo "🎨 Formatting the new files…"
    nixq fmt -- $files >/dev/null
    or echo "⚠️  nixpkgs-fmt failed; CI will report the formatting"
    echo "🔍 Linting…"
    nixq develop --command statix check $dir
    or echo "⚠️  statix reported problems; CI will fail until they are fixed"
    popd

    echo "🔍 Evaluating $name…"
    if nixq eval --raw "$repo#nixosConfigurations.$name.config.system.build.toplevel.drvPath" >/dev/null
        echo "✅ $name was added to the flake and evaluates"
    else
        echo "❌ $name was added, but does not evaluate yet; see the error above"
    end

    echo
    echo "Next steps:"
    echo "  • Review the files in hosts/$name/"
    if test $hardware = placeholder
        echo "  • On the target machine, replace hosts/$name/hardware-configuration.nix with the output"
        echo "    of 'nixos-generate-config --show-hardware-config'"
    end
    echo "  • Commit: git add hosts/$name flake.nix README.md && git commit -m 'feat: added host $name'"
    echo "  • On the target machine: sudo nixos-rebuild switch --flake .#$name"
    echo "  • Set a password: sudo passwd $user"
end

function main
    if fish_is_root_user
        echo "⚠️  Run this as your normal user; it calls sudo itself where needed."
    end
    while true
        echo
        set_color --bold
        echo "NixOS manager ($repo)"
        set_color normal
        choose "What do you want to do" \
            "Rebuild a host" \
            "Collect garbage" \
            "Add a new host" \
            Quit; or break
        switch $choice_index
            case 1
                rebuild_host
            case 2
                collect_garbage
            case 3
                add_host
            case 4
                break
        end
    end
end

main
