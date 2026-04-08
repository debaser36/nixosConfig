{ pkgs, custom-sddm-astronaut, ... }:
{
  specialisation."PERFORMANCE" = {
      services.blueman.enable = true;
      services.udev.extraRules = "";
      services.xserver.videoDrivers = ["amdgpu" "nvidia"];
  };
  services = {
    # power savings
    udev.extraRules = ''
      # Remove NVIDIA USB xHCI Host Controller devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"

      # Remove NVIDIA USB Type-C UCSI devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"

      # Remove NVIDIA Audio devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"

      # Remove NVIDIA VGA/3D controller devices
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
    '';
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
      videoDrivers = [ "amdgpu" ];
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
