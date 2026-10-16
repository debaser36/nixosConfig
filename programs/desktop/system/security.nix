_: {
  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  # Without this, anyone at the keyboard can add `init=/bin/sh` to the kernel command line
  boot.loader.systemd-boot.editor = false;
}
