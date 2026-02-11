_: {
  programs.kitty = {
    enable = true;
    enableGitIntegration = true;
    keybindings = {
      "ctrl+shift+up" = "launch --location=hsplit --cwd=current --bias=1";
      "ctrl+shift+down" = "launch --location=hsplit --cwd=current --bias=2";
      "ctrl+shift+left" = "launch --location=vsplit --cwd=current --bias=1";
      "ctrl+shift+right" = "launch --location=vsplit --cwd=current --bias=2";
    };
  };
}
