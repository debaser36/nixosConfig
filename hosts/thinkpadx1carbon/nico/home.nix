{ pkgs, ... }:
{
  home = {
    packages = import ./packageList.nix { inherit pkgs; };

    # ## DONT CHANGE THIS LINE!
    stateVersion = "25.05";
  };

  programs = {
    git.settings.user.email = "nico.burkholder@web.de";
    # Switches the Wi-Fi between hotspot and WLAN mode
    fish.shellAliases.toggleHotspot = "~/nixosConfig/programs/tools/hotspot_toggle/hotspottoggle.fish";
  };

  my.sway.monitors = import ../hardware/monitors.nix;
  wayland.windowManager.sway.config.input."12994:102:2.4G_Wireless_Mouse" = {
    accel_profile = "flat";
    drag = "enabled";
    pointer_accel = "-0.5";
  };

  imports = [
    # ssh: GitHub over port 443 and the server over port 2222, on top of the shared ssh config
    ./ssh.home.nix

    # changeKeyboardLayout: switch sway between US Standard, US Custom (Ctrl+a/o/u/s umlauts) and German
    ./keyboardLayout.nix

    # settings and programs shared by all desktop hosts
    ../../../programs/desktop/nico/home.nix
  ];
}
