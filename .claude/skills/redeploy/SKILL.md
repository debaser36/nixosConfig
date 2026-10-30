---
name: redeploy
description: Rebuilds and switches this machine to its NixOS configuration from this repository (optionally updating the flake inputs first). Without an argument it detects the configuration the machine runs and aborts if it cannot; with a host argument it applies that configuration.
argument-hint: "[host]"
disable-model-invocation: true
allowed-tools:
  - Bash(.claude/skills/redeploy/resolve-host.sh*)
  - Bash(git pull*)
  - Bash(git status*)
  - Bash(git diff*)
  - Bash(git commit *)
  - Bash(git push*)
  - Bash(nix flake update*)
  - Bash(nix build *)
  - Bash(nix store diff-closures *)
  - Bash(sudo -n nixos-rebuild switch --flake .#*)
---

# Redeploy

Applies a configuration of this flake to **this** machine with `nixos-rebuild switch`.
Argument: `$ARGUMENTS` (empty = detect the host).

This skill is the only exception to the rule in `CLAUDE.md` that forbids `sudo` and
`nixos-rebuild switch`. The exception covers exactly one command,
`sudo -n nixos-rebuild switch --flake .#<host>` in step 5, and only while running this skill.
Never run any other command with `sudo`, never use `boot`/`test`, never collect garbage.

Run every command from the repository root (`git rev-parse --show-toplevel`). Stop at the first
failing step, show its error, and do not work around it.

## 1. Pull

Run `git pull`. If it fails (conflicts, local changes blocking the merge), stop and tell the user.

## 2. Resolve the host

Run `.claude/skills/redeploy/resolve-host.sh $ARGUMENTS` (no argument if `$ARGUMENTS` is empty).

- Non-zero exit: show the script's error message verbatim and **stop**. Never pick a host
  yourself, never fall back to a guessed or "most likely" host, never retry with a host you chose.
- Success: it prints `host=` (the configuration to apply), `current=` (what the machine runs, or
  `unknown`) and `source=` (how `current` was found).
- If an argument was given and `current` is known but differs from `host`, ask with
  AskUserQuestion whether to really switch this machine (running `current`) to `host`, warning
  that another machine's configuration can leave it unbootable. Stop unless the user confirms.

## 3. Ask about updating the flake inputs

Always ask with AskUserQuestion, whether or not an argument was given:

- **Yes, all inputs**: `nix flake update`
- **Only `<host>`'s input set**: the set command from `CLAUDE.md` (desktop set for the desktops,
  server set for `nixos-oracle`)
- **No**: skip to step 4

If updating:

1. If `git status --porcelain flake.lock` shows uncommitted lock changes, stop and tell the user.
2. Run the chosen update command.
3. If `git diff --quiet flake.lock` reports no change, say the inputs were already current and go
   on to step 4.
4. Otherwise commit only the lock: `git commit -m "feat: upgraded flake" -m "<moved inputs>" flake.lock`
   (body: one line per input that moved, from the update output; end the message with the
   Co-Authored-By attribution line), then `git push`. If the push is rejected, stop and tell the
   user; do not force-push or rebase.

## 4. Build (without sudo)

1. Run `git status --porcelain`. If tracked files are modified, tell the user that the build
   includes those uncommitted changes (untracked files are invisible to the flake).
2. Build as the normal user, so build errors never need root:
   `nix build .#nixosConfigurations.<host>.config.system.build.toplevel --no-link --print-out-paths`
   (timeout 600000; on timeout rerun it with `run_in_background`).
3. Show what changes: `nix store diff-closures /run/current-system <out path>`. Summarise long
   output (version bumps of notable packages, total size change) instead of pasting it all.
   If the out path equals `readlink -f /run/current-system`, say the system is already up to date
   and stop.

## 5. Switch

Run `sudo -n nixos-rebuild switch --flake .#<host>` (timeout 600000). It reuses the build from
step 4.

`-n` makes sudo fail instead of waiting for a password. If it fails because a password is
required, do not try anything else with sudo; tell the user to run
`sudo nixos-rebuild switch --flake .#<host>` in a terminal in the repository (the build is cached).

## 6. Report

Check that `readlink -f /run/current-system` now equals the out path from step 4, then report the
host, whether the lock was updated (and the commit), the notable changes, and anything the switch
printed as a warning or failed unit. If `source=` was not `/etc/nixos-flake-host`, mention that
detection works from the marker file from now on.
