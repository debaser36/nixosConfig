{ pkgs
, lib
, custom-sddm-astronaut
, ...
}:
{
  specialisation."PERFORMANCE".configuration = {
    services.blueman.enable = lib.mkForce true;
  };
  services = {
    udisks2.enable = true;
    gvfs.enable = true;
    dbus.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver = {
      enable = true;
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
