# Additions to the shared desktop packages (programs/desktop/nico/packages.nix)
{ pkgs, ... }:
with pkgs;
[
  exercism
  discord

  # Development
  corepack # Node.js package manager manager
  python314
  libgcc
  gcc
  rocmPackages.llvm.clang-unwrapped
  cmakeWithGui

  # Databases
  pgmodeler
  sqlite

  # Wacom tablet
  xf86_input_wacom # X11 driver
  kdePackages.wacomtablet # configuration
]
