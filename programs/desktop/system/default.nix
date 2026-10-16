# System modules every desktop host imports. Hosts add their own modules (and optional shared ones
# such as bluetooth.nix) next to this one in their configuration.nix.
_: {
  imports = [
    ./environment.etc.nix
    ./systemPackages.nix
    ./services.nix
    ./audio.nix
    ./sddm.nix
    ./networking.nix
    ./nix_settings.nix
    ./users.nix
    ./environment.variables.nix
    ./fonts.nix
    ./security.nix
    ./waydroid.nix
  ];
}
