{ pkgs, ... }:
{
  home = {
    packages = import ./packageList.nix { inherit pkgs; };

    # ## DONT CHANGE THIS LINE!
    stateVersion = "25.05";
  };

  programs.git.settings.user.email = "nico.burkholder@web.de";

  my.sway.monitors = import ../hardware/monitors.nix;
  wayland.windowManager.sway.config.input."12994:102:2.4G_Wireless_Mouse" = {
    accel_profile = "flat";
    drag = "enabled";
    pointer_accel = "-0.5";
  };

  imports = [
    # ssh: GitHub over port 443 and the server over port 2222, on top of the shared ssh config
    ./ssh.home.nix

    # settings and programs shared by all desktop hosts
    ../../../programs/desktop/nico/home.nix
  ];
}
