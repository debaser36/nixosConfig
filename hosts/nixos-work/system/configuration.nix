_: {
  imports = [
    ../hardware/hardware-configuration.nix
    ../../../programs/desktop/system
    ./systemPackages.nix
    ./services.nix
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
