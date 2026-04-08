_: {
    hardware.nvidia = {
    open = false;
    # modesetting.enable = false;
      prime = {
       # TODO think about maybe using this only when saving battery instead of the stuff below ?
       offload = {
         enable = true;
    #    enableOffloadCmd = true;
       };  
       nvidiaBusId = "PCI:1@0:0:0";
       amdgpuBusId = "PCI:5@0:0:0";
     };
  };
}