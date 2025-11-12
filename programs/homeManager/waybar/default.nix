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
          interval = 60;
          format= "{:%d.%b %Y - %H:%M}";
        };
        "sway/workspaces"= {
          "format"= "{icon}";
          "on-click"= "activate";
          "format-icons"= {
            "urgent"= "";
            "active"= "";
            "default"= "";
          };
          "sort-by-number"= true;
        };
      };
    };
  };
}
