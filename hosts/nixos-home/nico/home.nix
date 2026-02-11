{ pkgs, ... }:
let

  monitors = import ../hardware/monitorInfo.nix;
  # sway
  outputConfig = import ../hardware/swayMonitorSettings.nix {
    inherit (monitors) center_monitor;
  };
  inputConfig = import ../hardware/swayInputSettings.nix {
    initial_output = monitors.center_monitor.name;
  };
  extraConfig = import ./swayExtraConfig.nix;
  startupConfig = import ./swayStartup.nix;
  #/sway

  packageList = import ./packageList.nix { inherit pkgs; };

  gitUser = {
    username = "debaser36";
    email = "n.burkholder@tu-berlin.de";
  };
in
{
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
    packages = packageList;

    # ## DONT CHANGE THIS LINE!
    stateVersion = "25.05";
  };


  _module.args = {
    inherit inputConfig;
    inherit outputConfig;
    inherit extraConfig;
    inherit startupConfig;
    inherit gitUser;
  };
  # Packages configurable via home manager config settings
  imports = [
    # sway
  ../../../programs/homeManager/sway/default.nix 

    # fish
    ../../../programs/homeManager/fish/default.nix
    # nvim
    ../../../programs/homeManager/neovim/default.nix

    # git
    ../../../programs/homeManager/git/default.nix

    # vscode
    ../../../programs/homeManager/vscode/default.nix

    # bash
    ../../../programs/homeManager/bash/default.nix

    # firefox
    ../../../programs/homeManager/firefox/default.nix

    # kitty
    ../../../programs/homeManager/kitty/default.nix

    # waybar
    ../../../programs/homeManager/waybar/default.nix

    # wofi
    ../../../programs/homeManager/wofi/default.nix

    # direnv
    ../../../programs/homeManager/direnv/default.nix

    # thunderbird
    ../../../programs/homeManager/thunderbird/default.nix
  ];

  programs.home-manager.enable = true;
}




