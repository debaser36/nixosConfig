# CLAUDE.md

NixOS + Home Manager configuration for five machines. One root `flake.nix` defines every host as
`nixosConfigurations.<host>`, named after its folder in `hosts/`. Shared modules live in
`programs/` and are imported by relative path (`../../../programs/...`).

## Hosts

| Host (= folder and flake output) | Machine                                  | Inputs                          |
|----------------------------------|------------------------------------------|---------------------------------|
| `thinkpadx1carbon`               | Lenovo ThinkPad X1 Carbon Gen 6 (laptop) | desktop set (nixos-unstable)    |
| `nixos-asus-laptop`              | Asus TUF Gaming 17 laptop                | desktop set (nixos-unstable)    |
| `nixos-home`                     | Home machine                             | desktop set (nixos-unstable)    |
| `nixos-work`                     | Work machine                             | desktop set (nixos-unstable)    |
| `nixos-oracle`                   | Server for unhalteproblem.de, aarch64    | server set (nixos-25.11)        |

- Desktop inputs: `nixpkgs`, `home-manager`, `nur`, `nix-vscode-extension`.
- Server inputs: `nixpkgs-stable`, `home-manager-stable`, `nur-stable`, `vscode-server`,
  `nixpkgs-unstable` (overlay source for the few packages that need to be newer than stable,
  currently just `claude-code`), plus `unhalteproblem-website` (the website, built with its own
  pinned nixos-unstable; nginx serves its `packages.<system>.default` straight from the Nix store).
- The two sets never share an input, so updating one set never changes the other hosts.
  Shared modules in `programs/` still affect both (e.g. the server imports the fish and neovim
  modules).
- Desktops are built with `mkDesktop`, every other host (including `nixos-oracle`) with `mkHost`,
  whose `specialArgs` passes flake inputs a host uses directly.

All desktop hosts have the hostname `nixos`, so `hostname` does not identify the machine.
The ThinkPad reports `20KHS2LF00` in `/sys/class/dmi/id/product_name`; otherwise ask which host
you are on.

Configuration shared by desktop hosts lives in `programs/desktop/` (`system/`, `nico/`, `assets/`,
mirroring a host folder). Every desktop's `system/configuration.nix` imports
`programs/desktop/system` (its `default.nix` lists the system modules all desktops share), then
optional shared modules (`bluetooth.nix` on the laptops) and its own files; `hosts/<host>/` keeps
hardware and real differences only.

- Changing a file in `programs/desktop/` changes every host that imports it: all four desktops for
  files listed in `programs/desktop/system/default.nix` or `programs/desktop/nico/home.nix`, otherwise
  `grep -rl "<file>" hosts/ programs/desktop/` lists them. Say which hosts are affected.
- A setting wanted on only one host goes into that host's files, not the shared module.
- The four desktops use the same shared base. On purpose they differ only in hardware, keyboard
  layout, time zone and locale, laptop power management, package lists, and their own extras in
  host-local files (e.g. `services.nix`, `systemPackages.nix` additions). When changing such a
  host-local setting, ask whether the other desktops should get it too. Never propagate silently.
- User packages: the shared base is `programs/desktop/nico/packages.nix`; `hosts/<host>/nico/packageList.nix`
  lists only additions. Don't list packages a module already installs (`programs.kitty`,
  `programs.waybar`, `programs.steam`, `programs.gnupg`, `programs.swaylock`, `services.swayidle`, `services.mako`).
- Sway: `programs/homeManager/sway/default.nix` is a module with `my.sway.monitors` (left to right,
  positions are computed) and `my.sway.primaryOutput`. Hosts list their monitors in
  `hosts/<host>/hardware/monitors.nix` and set inputs, keybindings and startup programs through
  `wayland.windowManager.sway.*` directly; host additions to shared text/lists use `lib.mkAfter`.
- `hardware-configuration.nix` holds hardware only; locale, boot loader and shared imports go
  into `configuration.nix`.
- Moving settings between files can reorder list options (`environment.systemPackages`,
  `home.packages`), which changes the built system even with the same contents. Verify
  restructurings with `nix-equivalence-check`.

## Commands

Run from the repo root.

- Validate a host: `nix build .#nixosConfigurations.<host>.config.system.build.toplevel --dry-run`
- Flake check (evaluates all hosts, runs the `format` and `statix` checks): `nix flake check`
- Format: `nix fmt` (nixpkgs-fmt from the pinned `nixpkgs`)
- Lint: `nix develop --command statix check .` (`statix.toml` skips generated `hardware-configuration.nix` files)
- `nix develop` gives a shell with nixpkgs-fmt, statix and nil
- Update the desktop inputs: `nix flake update nixpkgs home-manager nur nix-vscode-extension`
- Update the server inputs: `nix flake update nixpkgs-stable home-manager-stable nur-stable vscode-server nixpkgs-unstable`
- Deploy the website's latest `main`: `nix flake update unhalteproblem-website`, then rebuild
  `nixos-oracle`. The build lives in the website repo's `flake.nix`; its `pnpmDeps` hash is
  updated there whenever its `pnpm-lock.yaml` changes.
- The user applies a host with `sudo nixos-rebuild switch --flake .#<host>`

Flakes only see git-tracked files. Run `git add -N <file>` on new files before evaluating, or
evaluation fails with "path does not exist". The "Git tree is dirty" warning is harmless.

Never run `sudo`, `nixos-rebuild switch|boot|test` or garbage collection: the user applies
configurations themselves.

CI (`.github/workflows/check_nix.yaml`, on pushes and pull requests) runs `nix flake check`
(including formatting and statix), plus a dry-build for every host it lists from the flake.
`.github/workflows/update_flake_lock.yaml` opens a weekly pull request per input set
(`update_flake_lock_desktop`, `update_flake_lock_server`) and runs the checks on it; review those
with `flake-update-review` before merging. The website input is never updated automatically.

Both the desktops (30 days) and the server (14 days) collect garbage automatically once a week.

New hosts are created with the interactive tool `programs/tools/nixos_manager/nixosmanager.fish`
(it also rebuilds hosts and collects garbage). It writes `hosts/<name>/`, inserts a `mkHost` entry
above the `# nixos_manager: …` marker line in `flake.nix` (keep that line) and adds the host to
`README.md`. When adding a host by hand, do the same.

## Looking things up

Do not guess option or package names; options get renamed on unstable. Check against the version
the host pins:

- Option description (also proves it exists):
  `nix eval --raw .#nixosConfigurations.<host>.options.<option.path>.description`
- Home Manager option:
  `nix eval --raw .#nixosConfigurations.<host>.options.home-manager.users --apply 'o: (o.type.getSubOptions []).<option.path>.description'`
- Current value: `nix eval --json .#nixosConfigurations.<host>.config.<option.path>`
- Package version (overlays applied): `nix eval --raw .#nixosConfigurations.<host>.pkgs.<name>.version`
- Pinned source tree (read modules directly under `nixos/modules/`):
  `nix eval --raw --impure --expr '(builtins.getFlake (toString ./.)).inputs.nixpkgs.outPath'`
  (`nixpkgs-stable` for the server; `home-manager` / `home-manager-stable` for Home Manager,
  whose modules are under `modules/`)
- `lib` functions: `nix repl --file <nixpkgs-path>`, then `:doc lib.<name>`
- Breaking changes: `<nixpkgs-path>/nixos/doc/manual/release-notes/rl-<YYMM>.section.md` and
  `<home-manager-path>/docs/release-notes/rl-<YYMM>.md`

`man configuration.nix` and `man home-configuration.nix` also work, but they describe the
currently running system only, not other hosts or an updated lock.

## Secrets

The repo is pushed to GitHub (`debaser36/nixosConfig`) and the Nix store is world-readable. Never
put passwords, tokens or private keys into `.nix` files. Reference files that live only on the
target machine instead (e.g. `passwordFile = "/var/secrets/...";`). `.gitattributes` routes
`wireguardConfig.nix` through git-crypt, and `.gitignore` keeps it out unless added with `-f`
(git skips the filter silently in clones where git-crypt is not set up).

## Conventions

- Formatting is nixpkgs-fmt (leading-comma argument lists). Modules without arguments use `_:`.
- Never change `system.stateVersion`.
- Commit messages use the form `feat: xy`, `refactor: xy` or `fix: xy` (lowercase). Lock updates
  are `feat: upgraded flake`.

## Agents (`.claude/agents/`)

- `nix-check`: after editing `.nix` files or the lock; validates the affected hosts, returns only errors.
- `nix-options-lookup`: before using an option or package you have not verified in the pinned version.
- `flake-update-review`: after `nix flake update`, before the user switches.
- `nix-equivalence-check`: for refactors and cleanups; proves which hosts' built systems changed.
