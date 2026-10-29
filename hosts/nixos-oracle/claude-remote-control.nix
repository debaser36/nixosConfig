# Claude Code Remote Control: one system service per folder in
# vars.claude_remote_control_directories runs `claude remote-control` there as nico, so sessions in
# that folder can be started and used from claude.ai/code and the Claude app. The session name is
# the folder name. It uses nico's claude.ai login (~/.claude); a new folder must be trusted once by
# running `claude` in it interactively, until then its service fails and retries.
#
# Updates: on odd days of the month at 04:00, claude-code-update fetches the manifest of Anthropic's
# newest release from downloads.claude.ai and builds it with nixpkgs-unstable's claude-code package
# (the manifest carries the checksums) into /var/lib/claude-code/current, outside the flake lock.
# The services and the `claude` command in nico's shell run that build, or the flake-pinned
# claude-code until the first update ran (`sudo systemctl start claude-code-update`). Only a new
# build restarts the services, which ends the sessions running at that moment.
{ config, lib, pkgs, utils, nixpkgs-unstable, ... }:
let
  vars = import ./vars.nix;
  directories = vars.claude_remote_control_directories;
  unitName = dir: "claude-remote-control-${baseNameOf dir}";
  stateDir = "/var/lib/claude-code";

  claude = pkgs.writeShellScriptBin "claude" ''
    if [ -x ${stateDir}/current/bin/claude ]; then
      exec ${stateDir}/current/bin/claude "$@"
    fi
    exec ${lib.getExe pkgs.claude-code} "$@"
  '';

  # nixpkgs' claude-code package for the release the given manifest describes
  claudeFromManifest = pkgs.writeText "claude-code-from-manifest.nix" ''
    { manifestFile }:
    (import ${nixpkgs-unstable} {
      system = "${pkgs.stdenv.hostPlatform.system}";
      config.allowUnfree = true;
      overlays = [ ];
    }).claude-code.override {
      manifest = builtins.fromJSON (builtins.readFile manifestFile);
    }
  '';

  update = pkgs.writeShellApplication {
    name = "claude-code-update";
    runtimeInputs = [ pkgs.curl config.nix.package config.systemd.package ];
    text = ''
      base=https://downloads.claude.ai/claude-code-releases
      version=$(curl -fsSL --retry 3 "$base/latest")
      if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "unexpected version: $version" >&2
        exit 1
      fi
      curl -fsSL --retry 3 "$base/$version/manifest.zst.json" -o ${stateDir}/manifest.json

      old=$(readlink ${stateDir}/current || true)
      new=$(nix-build ${claudeFromManifest} --argstr manifestFile ${stateDir}/manifest.json --out-link ${stateDir}/current)
      if [[ $new == "$old" ]]; then
        echo "claude-code $version is already installed"
        exit 0
      fi
      echo "installed claude-code $version, restarting Remote Control"
      systemctl try-restart ${lib.escapeShellArgs (map (dir: "${unitName dir}.service") directories)}
    '';
  };

  # nico's login environment (PATH with the system and user profiles and the sudo wrapper, locale,
  # NIX_PATH, ...), which the commands run in the sessions need
  remoteControl = pkgs.writeShellScript "claude-remote-control" ''
    source ${config.system.build.setEnvironment}
    exec ${lib.getExe claude} remote-control --name "$1"
  '';
in
{
  home-manager.users.${vars.default_user.username}.home.packages = [ claude ];

  systemd = {
    services = lib.listToAttrs
      (map
        (dir: lib.nameValuePair (unitName dir) {
          description = "Claude Code Remote Control in ${dir}";
          wantedBy = [ "multi-user.target" ];
          wants = [ "network-online.target" ];
          after = [ "network-online.target" ];
          # nixos-rebuild switch is often run from one of these sessions, which a restart would end.
          # Changes apply at the next update, reboot or `systemctl restart`.
          restartIfChanged = false;
          # Keep retrying, e.g. without network or before the folder is trusted
          startLimitIntervalSec = 0;
          serviceConfig = {
            User = vars.default_user.username;
            WorkingDirectory = dir;
            ExecStart = utils.escapeSystemdExecArgs [ remoteControl (baseNameOf dir) ];
            Restart = "always";
            RestartSec = "30s";
            # stdout is a status display redrawn every few seconds (hundreds of MB per week)
            StandardOutput = "null";
          };
        })
        directories)
    // {
      claude-code-update = {
        description = "Update Claude Code to its newest release";
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = lib.getExe update;
          StateDirectory = "claude-code";
        };
      };
    };

    timers.claude-code-update = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        # Every other day; Persistent catches up on a run missed while the server was off
        OnCalendar = "*-*-1/2 04:00";
        Persistent = true;
      };
    };
  };
}
