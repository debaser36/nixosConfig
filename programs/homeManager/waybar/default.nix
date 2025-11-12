{
  programs.waybar = {
    enable = true;
    settings = {
      MainBar = {
        layer = "top";
        potition = "top";
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "battery" "clock" ];

        name = "MainBar";
        reload_style_on_change = false;

        # Module Settings
        battery = {
          format = "{capacity}% {icon}";
          format-icons = [ "" "" "" "" "" ];
        };
        clock = {
          format = "%a %d %b %Y %H:%M";
        };
      };
    };
  };
}
