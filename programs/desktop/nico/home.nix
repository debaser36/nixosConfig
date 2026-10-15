# Home Manager settings and programs shared by all desktop hosts
_: {
  home = {
    username = "nico";
    homeDirectory = "/home/nico";
    sessionPath = [
      "$HOME/bin"
      "$HOME/.pnpm-global"
      "$HOME/.npm-global/bin"
      "$HOME/.local/bin"
      "$HOME/go/bin"
    ];
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PNPM_HOME = "$HOME/.pnpm-global";
    };
  };

  imports = [
    ../../homeManager/fish/default.nix
    ../../homeManager/neovim/default.nix
    ../../homeManager/git/default.nix
    ../../homeManager/vscode/default.nix
    ../../homeManager/bash/default.nix
    ../../homeManager/firefox/default.nix
    ../../homeManager/kitty/default.nix
    ../../homeManager/waybar/default.nix
    ../../homeManager/wofi/default.nix
    ../../homeManager/direnv/default.nix
    ../../homeManager/thunderbird/default.nix
  ];

  programs.home-manager.enable = true;
}
