# Additions to the shared desktop packages (programs/desktop/nico/packages.nix)
{ pkgs, ... }:
with pkgs;
let
  rstudioCustom = rstudioWrapper.override {
    packages = with rPackages; [
      ggplot2
      dplyr
      xts
      shiny
      learnr
      nycflights13
      tidyverse
    ];
  };
in
[
  # minecraft
  prismlauncher

  # R
  rstudioCustom

  # Document Preparation & LaTeX
  texstudio # LaTeX IDE
  kdePackages.okular # pdf viewer

  # Emulation
  waydroid
  waydroid-helper
  nur.repos.ataraxiasjel.waydroid-script

  # Wacom tablet
  xf86_input_wacom # Wacom tablet X11 driver
  kdePackages.wacomtablet # Wacom tablet configuration

  # API Development & Database Tools
  bruno # API testing tool
  pgmodeler # PostgreSQL database modeler
  sqlite # SQLite database

  # Media creating and editing
  gimp3-with-plugins # the best image editor known to men and women
]
