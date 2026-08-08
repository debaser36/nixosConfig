{ pkgs, lib, ... }:
{
  hardware.graphics = lib.mkDefault {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };
}
