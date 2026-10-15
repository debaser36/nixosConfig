{ config
, lib
, modulesPath
, ...
}:
{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../../programs/desktop/system/bluetooth.nix
    ./fs.nix
    ./graphics.nix
    ./kernel.nix
    ./network.nix
    ./power.nix
    ../../../programs/desktop/system/security.nix
  ];

}
