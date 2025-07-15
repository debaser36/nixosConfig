{pkgs}:
{
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      dejavu_fonts
      liberation_ttf
      fira-code
      eb-garamond
      nerd-fonts.overpass
      nerd-fonts.zed-mono

    ];
  };

}