{ pkgs, lib, ... }:
{
  programs.steam = {
    enable = true;
    # Hosts that leave the home network (the laptops) turn these off
    remotePlay.openFirewall = lib.mkDefault true;
    dedicatedServer.openFirewall = lib.mkDefault true;
    localNetworkGameTransfers.openFirewall = lib.mkDefault true;
    protontricks = {
      enable = true;
    };
    package = pkgs.steam.override {
      extraPkgs =
        pkgs: with pkgs; [
          freetype
          fontconfig
          libpng
          libpulseaudio
        ];
    };
  };
}
