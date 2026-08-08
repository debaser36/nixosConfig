''
      	# bindsym Shift+T+Left input "1386:890:Wacom_One_by_Wacom_S_Pen" map_to_output "HDMI-A-1"
      	# bindsym Shift+T+Right input "1386:890:Wacom_One_by_Wacom_S_Pen" map_to_output "DP-1"
      	# bindsym Shift+T+Up input "1386:890:Wacom_One_by_Wacom_S_Pen" map_to_output "eDP-1"

      	bindsym Print			exec shotman -c output -C
      	bindsym Print+Shift		exec shotman -c region -C
      	bindsym Print+Shift+Control	exec shotman -c window -C
      	
      	bindsym L+K+J exec swaylock

      	# Audio Volume Controls (Sink - Output)
        bindsym XF86AudioRaiseVolume exec swayosd-client --output-volume raise
        bindsym XF86AudioLowerVolume exec swayosd-client --output-volume lower
        bindsym XF86AudioMute exec swayosd-client --output-volume mute-toggle

  			# Audio Volume Controls (Source - Input)`
  			bindsym XF86AudioMicMute exec swayosd-client --input-volume mute-toggle

  			# Brightness Controls
  			bindsym XF86MonBrightnessUp exec swayosd-client --brightness raise
  			bindsym XF86MonBrightnessDown exec swayosd-client --brightness lower

  			# Media Player Controls
  			bindsym XF86AudioPlay exec swayosd-client --playerctl play-pause
  			bindsym XF86AudioNext exec swayosd-client --playerctl next
  			bindsym XF86AudioPrev exec swayosd-client --playerctl prev
''
