{ left_monitor ? {
    name = "HDMI-A-1";
    width = 1920;
    height = 1200;
    refresh_rate = 59.950;
    rotation = "90";
  }
, center_monitor ? {
    name = "eDP-1";
    width = 1920;
    height = 1200;
    refresh_rate = 60.002;
    rotation = "normal";
  }
, right_monitor ? {
    name = "DP-1";
    width = 2560;
    height = 1440;
    refresh_rate = 59.951;
    rotation = "normal";
  }
}:
let
  left_mode = "${toString left_monitor.width}x${toString left_monitor.height}@${toString left_monitor.refresh_rate}Hz";
  center_mode = "${toString center_monitor.width}x${toString center_monitor.height}@${toString center_monitor.refresh_rate}Hz";
  right_mode = "${toString right_monitor.width}x${toString right_monitor.height}@${toString right_monitor.refresh_rate}Hz";

  # Calculate effective dimensions considering rotation
  left_effective_width = if left_monitor.rotation == "90" then left_monitor.height else left_monitor.width;
  left_effective_height = if left_monitor.rotation == "90" then left_monitor.width else left_monitor.height;

  center_effective_width = if center_monitor.rotation == "90" then center_monitor.height else center_monitor.width;
  center_effective_height = if center_monitor.rotation == "90" then center_monitor.width else center_monitor.height;

  right_effective_height = if right_monitor.rotation == "90" then right_monitor.width else right_monitor.height;

  # Position calculations
  left_position = "0,0";
  center_position = "${toString left_effective_width},${toString ((left_effective_height - center_effective_height) / 2)}";
  right_position = "${toString (left_effective_width + center_effective_width)},${toString ((left_effective_height - right_effective_height) / 2)}";
in
{
  output.${left_monitor.name} = {
    mode = left_mode;
    position = left_position;
    transform = left_monitor.rotation;
  };

  output.${center_monitor.name} = {
    mode = center_mode;
    position = center_position;
    transform = center_monitor.rotation;
  };


  output.${right_monitor.name} = {
    mode = right_mode;
    position = right_position;
    transform = right_monitor.rotation;
  };
}
