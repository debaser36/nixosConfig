{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
  };
  # Membership in the docker group is root-equivalent
  users.users.nico.extraGroups = [ "docker" ];
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
