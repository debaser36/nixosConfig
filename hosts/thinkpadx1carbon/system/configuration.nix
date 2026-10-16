_: {
  imports = [
    ../hardware/hardware-configuration.nix
    ../../../programs/desktop/system
    ../../../programs/desktop/system/bluetooth.nix
    ./services.nix
    ./sops.nix
  ];

  time.timeZone = "Pacific/Auckland";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  #DONT CHANGE THIS LINE
  system.stateVersion = "24.11"; # Did you read the comment?
}
