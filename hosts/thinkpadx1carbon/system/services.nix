{ lib, ... }:
{
  specialisation."PERFORMANCE".configuration = {
    services.blueman.enable = lib.mkForce true;
  };
  services.gvfs.enable = true;

  # Laptops join untrusted networks: no Steam ports open there
  programs.steam = {
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
    localNetworkGameTransfers.openFirewall = false;
  };
}
