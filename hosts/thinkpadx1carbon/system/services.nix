{ lib, ... }:
{
  specialisation."PERFORMANCE".configuration = {
    services.blueman.enable = lib.mkForce true;
  };
  services.gvfs.enable = true;
}
