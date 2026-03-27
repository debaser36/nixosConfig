{ pkgs
, nix-vscode-extension
, ...
}:
{
  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = "experimental-features = nix-command flakes lint-url-literals = fatal";
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
