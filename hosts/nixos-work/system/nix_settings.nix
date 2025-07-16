{
  pkgs,
  nix-vscode-extension,
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
       (final: prev: {
          clisp = prev.clisp.overrideAttrs (oldAttrs: {
          version="2.49.92";
          src = prev.fetchFromGitLab {
            owner = "gnu-clisp";
            repo = "clisp";
            rev = "bf72805c4dace982a6d3399ff4e7f7d5e77ab99a"; # this is actually 2.5
            hash = "sha256-sQoN2FUg9BPaCgvCF91lFsU/zLja1NrgWsEIr2cPiqo=";
          };
        });
      })
    ];
    config = {
      allowUnfree = true;
    };
  };
}