{
  pkgs,
  nix-vscode-extension,
}:
{
    nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = "experimental-features = nix-command flakes no-url-literals";
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