{ pkgs, nix-vscode-extension, ... }:

{
  imports = [
    ../hardware/hardware-configuration.nix
    ../../../programs/desktop/system/environment.etc.nix
    ./systemPackages.nix
    ../../../programs/system/npm.nix
    ../../../programs/desktop/system/audio.nix
    ../../../programs/desktop/system/sddm.nix
    ../../../programs/desktop/system/networking.nix
    ../../../programs/desktop/system/environment.variables.nix
    ../../../programs/desktop/system/security.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 2;
  };

  nixpkgs = {
    overlays = [
      nix-vscode-extension.overlays.default
    ];
    config.allowUnfree = true;
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";

  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = "experimental-features = nix-command flakes no-url-literals";
  };

  fonts.packages = [ pkgs.fira-code ];

  #virtualisation.virtualbox.guest.enable = true;
  console.keyMap = "de";

  users = {
    defaultUserShell = pkgs.fish;
    users.nico = {
      isNormalUser = true;
      description = "Default user for personal use of this system!";
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
      ];
      home = "/home/nico";
      shell = pkgs.fish;
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services = {
    dbus.enable = true;
    xserver = {
      wacom.enable = true;
      videoDrivers = [ "modesetting" ];
    };
    wg-netmanager.enable = true;
  };

  #DONT CHANGE THIS LINE
  system.stateVersion = "24.11"; # Did you read the comment?
}
