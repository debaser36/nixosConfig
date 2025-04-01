{
  programs.waybar = {
    enable = true;
    settings = {

        MainBar = {
          layer = "top";
          potition = "top";

          modules-left = [];
          modules-center = [];
          modules-right = ["battery"];

          name = "MainBar";
          reload_style_on_change = false;
        };
    };
  };
}