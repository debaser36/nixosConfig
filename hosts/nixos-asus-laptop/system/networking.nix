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
}
