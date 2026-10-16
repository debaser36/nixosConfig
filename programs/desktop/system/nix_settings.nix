{ pkgs
, nix-vscode-extension
, ...
}:
{
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      lint-url-literals = "fatal";
      download-buffer-size = 524288000;
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
  nixpkgs = {
    overlays = [
      nix-vscode-extension.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };
}
