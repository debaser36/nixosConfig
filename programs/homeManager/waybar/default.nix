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
        reload_style_on_change = true;

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
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10"= "10";

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
