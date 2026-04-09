{ lib, ... }:
{
  hardware.graphics = lib.mkDefault {
    enable = true;
    enable32Bit = true;
  };
  specialisation."PERFORMANCE".configuration = {
    hardware.nvidia = lib.mkForce {
      open = false;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        nvidiaBusId = "PCI:1@0:0:0";
        amdgpuBusId = "PCI:5@0:0:0";
      };
    };
  };
}
