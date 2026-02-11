{ pkgs, custom-sddm-astronaut }:
{
  virtualisation.docker = {
    enable = true;
  };
  services = {
    postgresql.enable = true;
    udisks2.enable = true;
    udev = {
      packages = [ pkgs.yubikey-personalization ];
    };

    pgadmin = {
      enable = true;
      initialEmail = "nico.burkholder@web.de";
    };

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
      videoDrivers = [ "modesetting" ];
      #windowManager.notion.enable = true;
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
