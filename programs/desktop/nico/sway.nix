# Sway settings shared by all desktop hosts. Hosts set `my.sway.monitors` and add their own
# inputs, keybindings and startup programs on top.
{ config, ... }:
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
}
