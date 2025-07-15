{ pkgs, nix-vscode-extension, ... }:

{
  imports =
    [
      ../hardware/hardware-configuration.nix
      (import ./environment.etc.nix)
      (import ./systemPackages.nix { inherit pkgs; })
      (import ./services.nix { inherit pkgs; })
      (import ./networking.nix)
      (import ./nix_settings.nix { inherit pkgs nix-vscode-extension; })
      (import ./users.nix { inherit pkgs; })
      (import ./environment.variables.nix)
      (import ./fonts.nix { inherit pkgs; })
    ];

  #DONT CHANGE THIS LINE
  system.stateVersion = "24.11"; # Did you read the comment?
}
