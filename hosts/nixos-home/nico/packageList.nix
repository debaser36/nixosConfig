# Additions to the shared desktop packages (programs/desktop/nico/packages.nix)
{ pkgs, ... }:
with pkgs;
[
  exercism
  discord

  # Databases
  pgmodeler
  sqlite

  # Wacom tablet
  xf86_input_wacom # X11 driver
  kdePackages.wacomtablet # configuration
]
