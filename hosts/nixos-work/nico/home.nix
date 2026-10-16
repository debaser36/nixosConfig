{ pkgs, lib, ... }:
{
  home = {
    packages = import ./packageList.nix { inherit pkgs; };

    # ## DONT CHANGE THIS LINE!
    stateVersion = "25.05";
  };

  programs.git.settings.user.email = "n.burkholder@tu-berlin.de";

  my.sway = {
    monitors = import ../hardware/monitors.nix;
    primaryOutput = "eDP-1";
  };
  wayland.windowManager.sway = {
    config.startup = lib.mkAfter [
      {
        command = "nohup element-desktop &";
        always = false;
      }
      {
        command = "nohup thunderbird &";
        always = true;
      }
    ];
    extraConfig = lib.mkAfter (import ./swayExtraConfig.nix);
  };

  # Packages configurable via home manager config settings
  imports = [
    # Discord
    ../../../programs/homeManager/discord/default.nix

    # Go
    ../../../programs/homeManager/go/default.nix

    # settings and programs shared by all desktop hosts
    ../../../programs/desktop/nico/home.nix

    # texlive
    ../../../programs/homeManager/texlive/default.nix

    # lutris
    ../../../programs/homeManager/lutris/default.nix
  ];
}
