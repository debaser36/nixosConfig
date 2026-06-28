# NixOS Configurations

Modular NixOS setup split into multiple host configurations and reusable program modules.

![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg) ![License](https://img.shields.io/badge/license-MIT-green.svg) 
![Last Commit](https://img.shields.io/github/last-commit/debaser36/nixosConfig) ![Repo Size](https://img.shields.io/github/repo-size/debaser36/nixosConfig)

---

## Overview

This repository manages multiple NixOS machines with a mix of system-level and user-level (Home Manager) configuration.

Each host is currently self-contained with its own `flake.nix`, allowing independent builds per machine while sharing common program modules.

---

## Repository Structure

```text
.
├── hosts/                     # Machine-specific NixOS configurations
│   ├── nixos-asus-laptop      # Gaming laptop setup
│   ├── nixos-home             # Home machine setup
│   ├── nixos-oracle           # Server / VPS configuration
│   ├── nixos-work             # Work machine setup
│
├── programs/                  # Shared configuration modules
│   ├── homeManager            # Home Manager modules (per app/tool)
│   ├── system                 # System-wide NixOS modules
│   └── tools                  # Utility scripts / helpers

```