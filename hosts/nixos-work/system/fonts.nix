{pkgs}:
let nerdfonts = pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; };
in
{
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      dejavu_fonts
      liberation-fonts
      fira-code
      eb-garamond
      overpass
      nerdfonts
    ];
  };
  serif = {
    package = pkgs.eb-garamond;
    name = "EB Garamond";
  };
  sansSerif = {
    package = pkgs.overpass;
    name = "Overpass";
  };
  monospace = {
    package = nerdfonts;
    name = "Iosevka Nerd Font Mono";
  };
  emoji = {
    package = pkgs.noto-fonts-emoji;
    name = "Noto Color Emoji";
  };
}