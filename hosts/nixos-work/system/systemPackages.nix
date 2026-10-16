# Additions to the shared desktop packages (programs/desktop/system/systemPackages.nix)
{ pkgs, ... }:
{
  imports = [
    ../../../programs/system/npm.nix
  ];
  environment.systemPackages = with pkgs; [
    notion-app-enhanced

    # Security & Authentication
    yubikey-manager # YubiKey management tool
  ];
}
