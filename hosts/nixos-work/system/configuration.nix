{ pkgs, nix-vscode-extension, ... }:
let
  custom-sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
  };
in
{
  imports =
    [
      ../hardware/hardware-configuration.nix
      ./environment.etc.nix
      (import ./systemPackages.nix { inherit pkgs custom-sddm-astronaut; })
      (import ./services.nix { inherit pkgs custom-sddm-astronaut; })
      ./networking.nix
      (import ./nix_settings.nix { inherit pkgs nix-vscode-extension; })
      ./users.nix
      ./environment.variables.nix
      ./fonts.nix
    ];

  #DONT CHANGE THIS LINE
  system.stateVersion = "24.11"; # Did you read the comment?
}
