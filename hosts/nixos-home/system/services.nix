_: {
  services.xserver = {
    wacom.enable = true;
    videoDrivers = [ "modesetting" ];
  };
}
