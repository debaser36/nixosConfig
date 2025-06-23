{
  programs.wofi = {
    enable = true;
    settings = {
      mode = "run";
      width = "60%";
      heigth = "80%";
      prompt = "Search for executables...";
      allow-markup = true;
      insensitive = true;
      columns = 2;
      gtK_dark = true;

      dynmaic_lines = true;
      single_click = true;

      key_up = "H";
      key_down = "J";
      key_left = "K";
      key_right = "L";


    };

  };
}
