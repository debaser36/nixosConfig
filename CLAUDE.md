# CLAUDE.md

NixOS + Home Manager configuration for five machines. There is **no root flake**: every
`hosts/<host>/` directory is a self-contained flake with its own `flake.lock`. Shared modules
live in `programs/` and are imported by relative path (`../../../programs/...`).

## Hosts

| Directory           | Machine                                   | Flake output                       | nixpkgs         |
|---------------------|-------------------------------------------|------------------------------------|-----------------|
| `thinkpadx1carbon`  | Lenovo ThinkPad X1 Carbon Gen 6 (laptop)  | `nixosConfigurations.nixos`        | nixos-unstable  |
| `nixos-asus-laptop` | Asus TUF Gaming 17 laptop                 | `nixosConfigurations.nixos`        | nixos-unstable  |
| `nixos-home`        | Home machine                              | `nixosConfigurations.nixos`        | nixos-unstable  |
| `nixos-work`        | Work machine                              | `nixosConfigurations.nixos`        | nixos-unstable  |
| `nixos-oracle`      | Server for unhalteproblem.de, aarch64     | `nixosConfigurations.nixos-oracle` | nixos-25.11     |

All desktop hosts have the hostname `nixos`, so `hostname` does not identify the machine.
The ThinkPad reports `20KHS2LF00` in `/sys/class/dmi/id/product_name`; otherwise ask which host
you are on.

The desktop hosts are near-copies of each other (`system/`, `hardware/`, `nico/`), and many files
are byte-identical between hosts. When changing a file in one host, check whether siblings have
the same file and ask whether to propagate the change. Never propagate silently.

## Commands

Run from the repo root. Replace `<host>`/`<output>` per the table above.

- Validate: `nix build ./hosts/<host>#nixosConfigurations.<output>.config.system.build.toplevel --dry-run`
- Flake check: `nix flake check ./hosts/<host>`
- Format: `nix run nixpkgs#nixpkgs-fmt -- .` (CI runs it with `--check`)
- Lint: `nix run nixpkgs#statix -- check .`
- Update inputs: `nix flake update --flake ./hosts/<host>`

Flakes only see git-tracked files. Run `git add -N <file>` on new files before evaluating, or
evaluation fails with "path does not exist". The "Git tree is dirty" warning is harmless.

Never run `sudo`, `nixos-rebuild switch|boot|test` or garbage collection: the user applies
configurations themselves.

CI (`.github/workflows/check_nix.yaml`) runs format, statix, flake check and a dry-build for every
host. A new host must be added to the CI matrix and to `README.md`.

## Looking things up

Do not guess option or package names; options get renamed on unstable. Check against the version
the host pins:

- Option description (also proves it exists):
  `nix eval --raw ./hosts/<host>#nixosConfigurations.<output>.options.<option.path>.description`
- Home Manager option:
  `nix eval --raw ./hosts/<host>#nixosConfigurations.<output>.options.home-manager.users --apply 'o: (o.type.getSubOptions []).<option.path>.description'`
- Current value: `nix eval --json ./hosts/<host>#nixosConfigurations.<output>.config.<option.path>`
- Package version (overlays applied): `nix eval --raw ./hosts/<host>#nixosConfigurations.<output>.pkgs.<name>.version`
- Pinned source tree (read modules directly under `nixos/modules/`):
  `nix eval --raw --impure --expr '(builtins.getFlake (toString ./hosts/<host>)).inputs.nixpkgs.outPath'`
  (use `.home-manager` for Home Manager; its modules are under `modules/`)
- `lib` functions: `nix repl --file <nixpkgs-path>`, then `:doc lib.<name>`
- Breaking changes: `<nixpkgs-path>/nixos/doc/manual/release-notes/rl-<YYMM>.section.md` and
  `<home-manager-path>/docs/release-notes/rl-<YYMM>.md`

`man configuration.nix` and `man home-configuration.nix` also work, but they describe the
currently running system only, not other hosts or an updated lock.

## Secrets

The repo is pushed to GitHub (`debaser36/nixosConfig`) and the Nix store is world-readable. Never
put passwords, tokens or private keys into `.nix` files. Reference files that live only on the
target machine instead (e.g. `passwordFile = "/var/secrets/...";`). `.gitattributes` routes
`wireguardConfig.nix` through git-crypt.

## Conventions

- Formatting is nixpkgs-fmt (leading-comma argument lists). Modules without arguments use `_:`.
- Never change `system.stateVersion`.
- Commit messages use the form `feat: xy`, `refactor: xy` or `fix: xy` (lowercase). Lock updates
  are `feat: upgraded flake`.

## Agents (`.claude/agents/`)

- `nix-check`: after editing `.nix` files or a lock; validates the affected hosts, returns only errors.
- `nix-options-lookup`: before using an option or package you have not verified in the pinned version.
- `flake-update-review`: after `nix flake update`, before the user switches.
