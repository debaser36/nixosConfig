# Additions to the shared sway keybindings (programs/desktop/nico/swayExtraConfig.nix):
# map the Wacom pen to an output
''
  bindsym Shift+T+Left input "1386:890:Wacom_One_by_Wacom_S_Pen" map_to_output "HDMI-A-1"
  bindsym Shift+T+Right input "1386:890:Wacom_One_by_Wacom_S_Pen" map_to_output "DP-2"
  bindsym Shift+T+Up input "1386:890:Wacom_One_by_Wacom_S_Pen" map_to_output "eDP-1"
''
