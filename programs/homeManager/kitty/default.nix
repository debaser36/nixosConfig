{
  programs.kitty = {
    enable = true;
    enableGitIntegration = true;
    keybindings = {
      "ctrl+shift+up" = "launch --location=hsplit --cwd=current";
      "ctrl+shift+down" = "launch --location=hsplit --cwd=current";
      "ctrl+shift+left" = "launch --location=vsplit --cwd=current";
      "ctrl+shift+right" = "launch --location=vsplit --cwd=current";
    };
  };
}
