{ pkgs }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    protontricks = {
      enable = true;
    };
    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        freetype
        fontconfig
        libpng
        libpulseaudio
      ];
    };
  };
}
