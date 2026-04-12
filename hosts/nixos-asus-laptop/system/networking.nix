_: {
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall = {
      checkReversePath = false;
      allowedUDPPorts = [ 51820 ];
    };
    wireguard.enable = true;
  };
  services.create_ap = {
  enable = true;
  settings = {
    INTERNET_IFACE = "enp5s0f3u2";
    WIFI_IFACE = "wlp3s0";
    SSID = "TetherTest";
    PASSPHRASE = "Passwort";
  };
};
}
