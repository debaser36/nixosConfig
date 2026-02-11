{ pkgs, nix-vscode-extension, ... }:
let
  custom-sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
  };
in
{
  _module.args = {
    inherit custom-sddm-astronaut;
    inherit nix-vscode-extension;
  };
  imports =
    [
      ../hardware/hardware-configuration.nix
      ./environment.etc.nix
      ./systemPackages.nix
      ./services.nix
      ./networking.nix
      ./nix_settings.nix
      ./users.nix
      ./environment.variables.nix
      ./fonts.nix
    ];

  #DONT CHANGE THIS LINE
  system.stateVersion = "24.11"; # Did you read the comment?
}
