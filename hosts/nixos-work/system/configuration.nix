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
      (import ./environment.etc.nix)
      (import ./systemPackages.nix { inherit pkgs custom-sddm-astronaut; })
      (import ./services.nix { inherit pkgs custom-sddm-astronaut; })
      (import ./networking.nix)
      (import ./nix_settings.nix { inherit pkgs nix-vscode-extension; })
      (import ./users.nix { inherit pkgs; })
      (import ./environment.variables.nix)
      (import ./fonts.nix { inherit pkgs; })
    ];

  #DONT CHANGE THIS LINE
  system.stateVersion = "24.11"; # Did you read the comment?
}
