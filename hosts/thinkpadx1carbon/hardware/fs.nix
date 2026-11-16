# Full disk encryption: the root partition is a LUKS2 container labelled NIXCRYPT
# (`cryptsetup luksFormat --type luks2 --label NIXCRYPT`), holding the ext4 root NIXROOT.
# /boot (NIXBOOT) stays unencrypted, systemd-boot and the initrd have to be readable.
_: {
  boot.initrd = {
    # Unlocked in the initrd with a passphrase prompt, typed in the console keymap (us)
    luks.devices.cryptroot = {
      device = "/dev/disk/by-label/NIXCRYPT";
      # Passes TRIM through to the SSD (services.fstrim). Reveals which blocks are unused, not their content
      allowDiscards = true;
      # Skips dm-crypt's internal work queues, faster on NVMe SSDs
      bypassWorkqueues = true;
    };
    # AES-NI is a kernel module; without it in the initrd, dm-crypt picks the slow generic AES
    availableKernelModules = [ "aesni_intel" "cryptd" ];
  };

  fileSystems."/" = {
    device = "/dev/mapper/cryptroot";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXBOOT";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ ];
}
