{lib,...}:{
  boot = {
    initrd = {
      kernelModules = lib.mkDefault [ ];
      availableKernelModules = [ "usbhid" "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" "ahci" ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 5;
    };
  };
}