_:{
    # on normal mode, just disable nvidia generally
    boot.extraModprobeConfig = ''
      blacklist nouveau
      options nouveau modeset=0
    '';

    boot.blacklistedKernelModules = [
      "nouveau"
      "nvidia"
      "nvidia_drm"
      "nvidia_modeset"
    ]; 
  specialisation."PERFORMANCE".configuration = {
    boot.extraModprobeConfig = "";
    boot.blacklistedKernelModules = [];
  };
  boot = {
    initrd = {
      kernelModules = [ ];
      availableKernelModules = [ "usbhid" "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" "ahci" ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 2;
    };
  };
}