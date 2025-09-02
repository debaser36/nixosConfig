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
  virtualisation.waydroid.enable = true;
  nixpkgs = {
    overlays = [
      nix-vscode-extension.overlays.default
      /* (
        final: prev: {
          flutter = prev.flutter319;
        }
      ) */
      /* (final: prev: {
          clisp = prev.clisp.override {
          # On newer readline8 fails as:
          #  #<FOREIGN-VARIABLE "rl_readline_state" #x...>
          #   does not have the required size or alignment
          readline = pkgs.readline70;
      };
      }) */
    ];
    config = {
      allowUnfree = true;
    };
  };
}
