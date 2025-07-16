{ pkgs }:
let
  custom-sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
  };
in
{
  imports = [
    (import ../../../programs/system/npm.nix)
    (import ../../../programs/system/fish.nix)
    (import ../../../programs/system/sway.nix)
    (import ../../../programs/system/steam.nix)
    (import ../../../programs/system/gnupg.nix)
  ];
  #packages needed for flakes to work
  environment.systemPackages = with pkgs; with pkgs.kdePackages;
    [
      # sddm theme
      custom-sddm-astronaut
      qtbase
      qtmultimedia
      qttools
      qtvirtualkeyboard
      qtsvg

      # needed base programs
      git
      vim
      wget
      wlroots
      xorg.xrandr
      procps

      ## yubikey
      yubikey-manager

      automake117x
      #clisp
    ];
}
