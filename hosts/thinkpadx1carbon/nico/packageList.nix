# Additions to the shared desktop packages (programs/desktop/nico/packages.nix)
{ pkgs, ... }:
with pkgs;
[
  claude-code
  glib

  # Music
  mixxx
  yt-dlp # download tracks

  # Android
  scrcpy
  android-tools

  exercism

  # Secrets (sops-nix): sops edits secrets/*.yaml, age creates keys
  sops
  age
  discord

  # isabelle (proof assistant) disabled for now; the other desktops install it
]
