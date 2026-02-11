{ pkgs, ... }:
with pkgs.nur.repos.rycee.firefox-addons; [
  privacy-badger
  bitwarden
  sponsorblock
  ublock-origin
  unpaywall
]
