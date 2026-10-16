# Sway settings shared by all desktop hosts. Hosts set `my.sway.monitors` and add their own
# inputs, keybindings and startup programs on top.
{ config, lib, ... }:
let
  swaylock = "${config.programs.swaylock.package}/bin/swaylock -f";
  swaymsg = lib.getExe' config.wayland.windowManager.sway.package "swaymsg";
in
{
  imports = [ ../../homeManager/sway/default.nix ];

  wayland.windowManager.sway = {
    config = {
      input."1386:890:Wacom_One_by_Wacom_S_Pen".map_to_output = config.my.sway.primaryOutput;
      startup = [
        {
          command = "nohup firefox &";
          always = false;
        }
      ];
    };
    extraConfig = import ./swayExtraConfig.nix;
  };

  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
      show-failed-attempts = true;
    };
  };

  # Lock after 5 minutes, screens off after 10, and lock before suspend
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = swaylock;
      }
      {
        timeout = 600;
        command = "${swaymsg} 'output * power off'";
        resumeCommand = "${swaymsg} 'output * power on'";
      }
    ];
    events.before-sleep = swaylock;
  };

  # Notifications (notify-send)
  services.mako = {
    enable = true;
    settings.default-timeout = 5000;
  };
}
