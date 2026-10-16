{ pkgs, ... }:
{

  imports = [
    ../../system/fish.nix
    ../../system/sway.nix
    ../../system/steam.nix
    ../../system/gnupg.nix
  ];

  environment.systemPackages =
    with pkgs;
    with pkgs.kdePackages;
    [
      # Qt libraries for the sddm theme (sddm.nix)
      qtbase
      qtmultimedia
      qttools
      qtvirtualkeyboard
      qtsvg

      git
      vim

      wget
      xrandr
      procps

      # graphic testing
      mesa-demos
    ];

}
