{lib,...}:
{
  specialisation."PERFORMANCE".configuration = {
    hardware.bluetooth = lib.mkForce {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
  };
}