{ pkgs, ... }:
let
  custom-sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
  };
in
{
  environment.systemPackages = [ custom-sddm-astronaut ];

  services.displayManager = {
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
}
