 {
		left_monitor ? {
			name= "eDP-1";
			width= 1920;
			height= 1200;
			refresh_rate= 59.950;
			rotation= "90";
		},

		center_monitor ? {
			name= "HDMI-A-1";
			width= 1920;
			height= 1200;
			refresh_rate= 60.002;
			rotation= "0";
		},

		right_monitor ? {
			name= "DP-1";
			width= 2560;
			height= 1440;
			refresh_rate= 59.951;
			rotation= "0";
		}
 }:
 let
	left_mode = "${left_monitor.width}x${left_monitor.height}@${left_monitor.refresh_rate}Hz";
	center_mode = "${center_monitor.width}x${center_monitor.height}@${center_monitor.refresh_rate}Hz";
	right_mode = "${right_monitor.width}x${right_monitor.height}@${right_monitor.refresh_rate}Hz";

	left_position = "0,0";
	center_position = "${left_monitor.width},${left_monitor.height / 5}";
	right_position = "${left_monitor.width + center_monitor.width},${left_monitor.height / 5 - 120}";
in
 {
					output.${left_monitor.name} = {
						mode=left_mode;
						position=left_position;
						transform=left_monitor.rotation;
					};

					output.${center_monitor.name} = {
						mode=center_mode;
						position=center_position;
						transform=center_monitor.rotation;
					};

  
					output.${right_monitor.name} = {
						mode=right_mode;
						position=right_position;
						transform=right_monitor.rotation;
					};
	}