{ pkgs, ... }:
{
  home = {
    packages = import ./packageList.nix { inherit pkgs; };

    # ## DONT CHANGE THIS LINE!
    stateVersion = "25.05";
  };

  _module.args.user = {
    username = "debaser36";
    email = "n.burkholder@tu-berlin.de";
  };

  my.sway.monitors = import ../hardware/monitors.nix;
  wayland.windowManager.sway = {
    extraOptions = [ "--unsupported-gpu" ];
    config.input."12994:102:2.4G_Wireless_Mouse" = {
      accel_profile = "flat";
      drag = "enabled";
      pointer_accel = "-0.5";
    };
  };

  imports = [
    # settings and programs shared by all desktop hosts
    ../../../programs/desktop/nico/home.nix
  ];
}
