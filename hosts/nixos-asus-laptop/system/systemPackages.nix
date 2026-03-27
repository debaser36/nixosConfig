{ pkgs, custom-sddm-astronaut, ... }:
{

  imports = [
    ../../../programs/system/npm.nix
    ../../../programs/system/fish.nix
    ../../../programs/system/sway.nix
    ../../../programs/system/steam.nix
    ../../../programs/system/gnupg.nix
  ];

  #packages needed for flakes to work
  environment.systemPackages = with pkgs; with pkgs.kdePackages;
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
    ];


}
