# NixOS Configurations

Modular NixOS setup split into multiple host configurations and reusable program modules.

![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg) ![License](https://img.shields.io/badge/license-MIT-green.svg) 
![Last Commit](https://img.shields.io/github/last-commit/debaser36/nixosConfig) ![Repo Size](https://img.shields.io/github/repo-size/debaser36/nixosConfig)

---

## Overview

This repository manages multiple NixOS machines with a mix of system-level and user-level (Home Manager) configuration.

A single `flake.nix` at the repository root defines every host as `nixosConfigurations.<host>`, named after its folder in `hosts/`. All desktop hosts share one pinned set of inputs on nixos-unstable; `nixos-oracle` uses its own `-stable` inputs on nixos-25.11.

---

## Repository Structure

```text
.
├── flake.nix                  # Defines all hosts
├── flake.lock                 # Pinned inputs for all hosts
├── hosts/                     # Machine-specific NixOS configurations
│   ├── nixos-asus-laptop      # Gaming laptop setup
│   ├── nixos-home             # Home machine setup
│   ├── nixos-oracle           # Server / VPS configuration
│   ├── nixos-work             # Work machine setup
│   ├── thinkpadx1carbon       # Lenovo ThinkPad X1 Carbon (Gen 6) laptop
│
├── programs/                  # Shared configuration modules
│   ├── homeManager            # Home Manager modules (per app/tool)
│   ├── system                 # System-wide NixOS modules
│   └── tools                  # Utility scripts / helpers

```

---

## Usage

```sh
# Apply a host's configuration (run from the repository root)
sudo nixos-rebuild switch --flake .#thinkpadx1carbon

# On nixos-oracle the hostname matches, so this is enough
sudo nixos-rebuild switch --flake .

# Update the desktop hosts' inputs
nix flake update nixpkgs home-manager nur nix-vscode-extension

# Update the server's inputs
nix flake update nixpkgs-stable home-manager-stable nur-stable vscode-server compose2nix
```
