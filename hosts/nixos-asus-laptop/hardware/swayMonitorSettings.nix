{ center_monitor ? {
    name = "DP-2";
    width = 2560;
    height = 1440;
    refresh_rate = 59.951;
    rotation = "normal";
  }
}:
let
  center_mode = "${toString center_monitor.width}x${toString center_monitor.height}@${toString center_monitor.refresh_rate}Hz";
  # Position calculations
  center_position = "0,0";
in
{
  output.${center_monitor.name} = {
    mode = center_mode;
    position = center_position;
    transform = center_monitor.rotation;
  };
}
