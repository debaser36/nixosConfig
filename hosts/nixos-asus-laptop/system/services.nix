{ pkgs, custom-sddm-astronaut, ... }:
{
  services = {
    udisks2.enable = true;
    dbus.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver = {
      enable = true;
      wacom.enable = true;
      videoDrivers = [ "modesetting" "nvidia" ];
    };
    wg-netmanager.enable = true;
    pcscd.enable = true;
    displayManager = {
      defaultSession = "sway";
      sddm = {
        enable = true;
        package = pkgs.kdePackages.sddm;
        wayland = {
          enable = true;
          compositor = "weston";
        };
        theme = "sddm-astronaut-theme";
        autoNumlock = true;
        enableHidpi = true;
        settings = {
          Theme = {
            Current = "sddm-astronaut-theme";
            CursorTheme = "Bibata-Modern-Ice";
            CursorSize = 24;
          };
        };
        extraPackages = [ custom-sddm-astronaut ];
      };
    };
  };
}
