{ pkgs
, nix-vscode-extension
, ...
}:
{
  time.timeZone = "Pacific/Auckland";
  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";
  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes 
      lint-url-literals = fatal
    '';
    settings.download-buffer-size = 524288000;
  };
  virtualisation.waydroid.enable = true;
  nixpkgs = {
    overlays = [
      nix-vscode-extension.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };
}
