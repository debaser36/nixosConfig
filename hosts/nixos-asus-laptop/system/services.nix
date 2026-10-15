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
}
