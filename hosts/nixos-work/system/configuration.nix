_: {
  imports = [
    ../hardware/hardware-configuration.nix
    ../../../programs/desktop/system/environment.etc.nix
    ../../../programs/desktop/system/systemPackages.nix
    ./systemPackages.nix
    ./services.nix
    ../../../programs/desktop/system/services.nix
    ../../../programs/desktop/system/audio.nix
    ../../../programs/desktop/system/sddm.nix
    ../../../programs/desktop/system/networking.nix
    ../../../programs/desktop/system/nix_settings.nix
    ../../../programs/desktop/system/users.nix
    ../../../programs/desktop/system/environment.variables.nix
    ../../../programs/desktop/system/fonts.nix
    ../../../programs/desktop/system/security.nix
    ../../../programs/desktop/system/waydroid.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 2;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";

  #DONT CHANGE THIS LINE
  system.stateVersion = "24.11"; # Did you read the comment?
}
