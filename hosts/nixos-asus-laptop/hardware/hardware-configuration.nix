{ config, lib, modulesPath, ... }:
{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./bluetooth.nix
      ./fs.nix
      ./graphics.nix
      ./kernel.nix
      ./network.nix
      ./power.nix
      ./security.nix
    ];

}
