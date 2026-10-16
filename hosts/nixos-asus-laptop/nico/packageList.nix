# Additions to the shared desktop packages (programs/desktop/nico/packages.nix)
{ pkgs, ... }:
with pkgs;
[
  # Music
  mixxx
  yt-dlp # download tracks

  # Android
  scrcpy
  android-tools

  exercism
  discord
]
