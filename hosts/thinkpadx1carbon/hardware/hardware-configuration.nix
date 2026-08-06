{ config
, lib
, modulesPath
, ...
}:
{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;

  imports = [
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
