''
	# bindsym Shift+T+Left input "1386:890:Wacom_One_by_Wacom_S_Pen" map_to_output "HDMI-A-1"
	# bindsym Shift+T+Right input "1386:890:Wacom_One_by_Wacom_S_Pen" map_to_output "DP-1"
	# bindsym Shift+T+Up input "1386:890:Wacom_One_by_Wacom_S_Pen" map_to_output "eDP-1"

	bindsym Print			exec shotman -c output -C
	bindsym Print+Shift		exec shotman -c region -C
	bindsym Print+Shift+Control	exec shotman -c window -C
	
	bindsym L+K+J exec swaylock

	bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +1%
	bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -1%
	bindsym Shift+XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
	bindsym Shift+XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
''
