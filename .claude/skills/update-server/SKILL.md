---
name: update-server
description: Updates the server's flake inputs (optionally also the unhalteproblem.de website), builds nixos-oracle, commits and pushes the lock, then switches the server to it. Runs only on the server itself.
argument-hint: "[website]"
disable-model-invocation: true
allowed-tools:
  - Bash(.claude/skills/redeploy/resolve-host.sh)
  - Bash(git pull*)
  - Bash(git status*)
  - Bash(git diff*)
  - Bash(git commit *)
  - Bash(git push*)
  - Bash(nix flake update *)
  - Bash(nix build *)
  - Bash(nix store diff-closures *)
  - Bash(readlink *)
  - Bash(systemctl --failed*)
  - Bash(curl -fsS -o /dev/null -w *)
  - Bash(sudo -n nixos-rebuild switch --flake .#nixos-oracle)
---

# Update server

Updates the flake inputs of `nixos-oracle` and switches **this** machine, which must be the server,
to the result. Argument: `$ARGUMENTS`

- empty: update the server input set (the "Update the server inputs" command in `CLAUDE.md`)
- `website`: the server input set plus `unhalteproblem-website`, which also deploys the website's
  latest `main` (frontend and backend)
- anything else: stop and show these two forms

This skill is one of the two exceptions (with `/redeploy`) to the rule in `CLAUDE.md` that forbids
`sudo` and `nixos-rebuild switch`. The exception covers exactly one command,
`sudo -n nixos-rebuild switch --flake .#nixos-oracle` in step 6, and only while running this skill.
Never run any other command with `sudo`, never use `boot`/`test`, never collect garbage, never
reboot.

Switching from a Remote Control session is safe: those services set `restartIfChanged = false`
(`hosts/nixos-oracle/claude-remote-control.nix`), so the switch does not end this session. Other
services that changed (nginx, the backend container, Keycloak, PostgreSQL) do restart.

Run every command from the repository root (`git rev-parse --show-toplevel`). Stop at the first
failing step, show its error, and do not work around it.

## 1. Pull

Run `git pull`. If it fails (conflicts, local changes blocking the merge), stop and tell the user.

## 2. Make sure this is the server

Run `.claude/skills/redeploy/resolve-host.sh` without an argument. Continue only if it succeeds and
prints `host=nixos-oracle`. Otherwise stop and tell the user that this skill only runs on the server
(on a desktop, `/redeploy` updates and switches that machine). Never pass a host argument and never
build for the server from another machine.

## 3. Update the lock

1. If `git status --porcelain flake.lock` shows uncommitted lock changes, stop and tell the user.
2. Run the server set command from `CLAUDE.md`. With `website`, append `unhalteproblem-website` to
   that same command (one update, one commit).
3. Note every input that moved from the update output (`Updated input '…'`, old and new revision
   with their dates).
4. If `git diff --quiet flake.lock` reports no change, say the inputs were already current and go on
   anyway: step 4 still shows whether the running system lags behind the repository (e.g. a merged
   lock pull request that was never switched to).

## 4. Build (without sudo)

1. Run `git status --porcelain`. If tracked files other than `flake.lock` are modified, tell the
   user that the build includes those uncommitted changes.
2. Build as the normal user, so build errors never need root:
   `nix build .#nixosConfigurations.nixos-oracle.config.system.build.toplevel --no-link --print-out-paths`
   (timeout 600000; on timeout rerun it with `run_in_background`; a website update can rebuild the
   frontend and the backend image, which takes longer).
3. If the build fails: show the error and stop **before committing**. Leave `flake.lock` as updated
   and tell the user that `git checkout flake.lock` drops the update. A `pnpmDeps` hash mismatch
   comes from the website repository, whose `flake.nix` needs the new hash; it is not fixed here.
4. Keep any `evaluation warning:` lines the build printed for the report.
5. Show what changes: `nix store diff-closures /run/current-system <out path>`. Summarise long output
   (version bumps of notable packages such as the kernel, nginx, PostgreSQL, Keycloak, the website,
   and the total size change) instead of pasting it all.
6. If the out path equals `readlink -f /run/current-system`, the system is already up to date: do
   step 5 if the lock changed, skip step 6, and report.

## 5. Commit and push the lock

Only if `flake.lock` changed: `git commit -m "feat: upgraded flake" -m "<moved inputs>" flake.lock`
(body: one line per input that moved, with old and new date; end the message with the
Co-Authored-By attribution line), then `git push`. If the push is rejected, stop **before
switching** and tell the user; do not force-push or rebase. Pushing first keeps the running server
on a configuration that exists on GitHub.

## 6. Switch

Run `sudo -n nixos-rebuild switch --flake .#nixos-oracle` (timeout 600000). It reuses the build
from step 4.

`-n` makes sudo fail instead of waiting for a password. If it fails because a password is required,
do not try anything else with sudo; tell the user to run
`sudo nixos-rebuild switch --flake .#nixos-oracle` in a terminal in the repository (the build is
cached).

## 7. Verify and report

1. Check that `readlink -f /run/current-system` now equals the out path from step 4.
2. `systemctl --failed --no-legend`: name every failed unit (expected: none).
3. `curl -fsS -o /dev/null -w '%{http_code}\n' --max-time 20 https://unhalteproblem.de/` must
   print `200`.
4. If `readlink /run/booted-system/kernel` differs from `readlink /run/current-system/kernel`, the
   new kernel only runs after a reboot; say so, but leave rebooting to the user.

Then report: which inputs moved and the commit (or that they were already current), the notable
changes from the closure diff, evaluation warnings, anything the switch printed as a warning or
failed unit, and the results of the checks above. If the lock changed, mention that an open weekly
`update_flake_lock_server` pull request is now superseded and can be closed. If `claude-code` or the
Remote Control units changed, add that running sessions keep their old version until the next
`claude-code-update`, a reboot or a restart of their service.
