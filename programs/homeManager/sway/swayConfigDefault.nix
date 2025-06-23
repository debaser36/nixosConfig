{ modifier ? "Mod4"
, terminal ? "kitty"
, colors ? (import ./swayColorsDefault.nix)
, bgPath ? "/etc/default_wallpaper.jpg fill"
, ...
}:
{
  focus.followMouse = false;
  inherit modifier;
  menu = "wofi --show run";
  bars = [
    {
      command = "waybar";
    }
  ];
  inherit terminal;
  window = {
    border = 5;
  };
  inherit colors;

  input = {
    "*" = { xkb_layout = "de"; };
  };


  output."*".bg = bgPath;

}
