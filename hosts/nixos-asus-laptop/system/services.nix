{ lib, ... }:
{
  specialisation."PERFORMANCE".configuration = {
    services.blueman.enable = lib.mkForce true;
    services.xserver.videoDrivers = lib.mkForce [
      "amdgpu"
      "nvidia"
    ];
  };
  services = {
    upower.enable = true;
    xserver.videoDrivers = lib.mkDefault [ "amdgpu" ];
  };

  # Laptops join untrusted networks: no Steam ports open there
  programs.steam = {
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
    localNetworkGameTransfers.openFirewall = false;
  };
}
