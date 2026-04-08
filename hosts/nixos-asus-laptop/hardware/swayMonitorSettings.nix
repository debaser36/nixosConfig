{ center_monitor ? {
    name = "eDP-1";
    width = 1920;
    height = 1080;
    refresh_rate = 60.003;
    rotation = "normal";
  }
}:
let
  center_mode = "${toString center_monitor.width}x${toString center_monitor.height}@${toString center_monitor.refresh_rate}Hz";
  center_position = "0,0";
in
{
  output.${center_monitor.name} = {
    mode = center_mode;
    position = center_position;
    transform = center_monitor.rotation;
  };
}
