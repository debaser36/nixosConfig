{ pkgs, custom-sddm-astronaut, ... }:
{
  imports = [
    ../../../programs/system/npm.nix
    ../../../programs/system/fish.nix
    ../../../programs/system/sway.nix
    ../../../programs/system/steam.nix
    ../../../programs/system/gnupg.nix
  ];
  environment.systemPackages = with pkgs; with pkgs.kdePackages;
    [
      # gaming emulation
      # lutris-unwrapped
      notion-app-enhanced

      # Display Manager & Desktop Environment
      custom-sddm-astronaut # Custom SDDM theme

      # Qt Framework & Components
      qtbase # Core Qt library
      qtmultimedia # Qt multimedia support
      qttools # Qt development tools
      qtvirtualkeyboard # Qt virtual keyboard
      qtsvg # Qt SVG support

      # Development Tools
      git # Version control system
      vim # Text editor
      # automake117x # GNU build system generator

      # System Utilities
      wget # Network downloader
      xrandr # Display configuration utility
      procps # Process monitoring tools

      # Wayland Compositor
      wlroots # Wayland compositor library

      # Security & Authentication
      yubikey-manager # YubiKey management tool
    ];
}
