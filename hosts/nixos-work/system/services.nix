{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
  };
  services = {
    postgresql.enable = true;
    udev = {
      packages = [ pkgs.yubikey-personalization ];
    };

    pgadmin = {
      enable = true;
      initialEmail = "nico.burkholder@web.de";
      initialPasswordFile = "/var/secrets/pgadmin_pass";
    };

    xserver = {
      wacom.enable = true;
      videoDrivers = [ "modesetting" ];
    };
  };
}
