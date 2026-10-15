{ pkgs, custom-sddm-astronaut, ... }:
{

  imports = [
    ../../system/fish.nix
    ../../system/sway.nix
    ../../system/steam.nix
    ../../system/gnupg.nix
  ];

  #packages needed for flakes to work
  environment.systemPackages =
    with pkgs;
    with pkgs.kdePackages;
    [
      custom-sddm-astronaut
      qtbase
      qtmultimedia
      qttools
      qtvirtualkeyboard
      qtsvg

      git
      vim

      wget
      wlroots
      xrandr
      procps

      # graphic testing
      mesa-demos
    ];

}
