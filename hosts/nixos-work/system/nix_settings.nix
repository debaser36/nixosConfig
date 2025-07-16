{ pkgs
, nix-vscode-extension
,
}:
{
  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = "experimental-features = nix-command flakes no-url-literals";
    settings.download-buffer-size = 524288000;
  };
  nixpkgs = {
    overlays = [
      nix-vscode-extension.overlays.default
      /* (
        final: prev: {
          flutter = prev.flutter319;
        }
      ) */
    ];
    config = {
      allowUnfree = true;
    };
  };
}
