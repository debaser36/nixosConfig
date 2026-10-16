{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
  };
  services = {
    udev = {
      packages = [ pkgs.yubikey-personalization ];
    };

    xserver = {
      wacom.enable = true;
      videoDrivers = [ "modesetting" ];
    };
  };
}
