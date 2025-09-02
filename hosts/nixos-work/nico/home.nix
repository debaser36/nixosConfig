{ pkgs, lib, ... }:
let

  monitors = import ../hardware/monitorInfo.nix;
  outputConfig = import ../hardware/swayMonitorSettings.nix {
    inherit (monitors) left_monitor;
    inherit (monitors) center_monitor;
    inherit (monitors) right_monitor;
  };
  inputConfig = import ../hardware/swayInputSettings.nix {
    initial_output = monitors.center_monitor.name;
  };
  extraConfig = import ./swayExtraConfig.nix;
  startupConfig = import ./swayStartup.nix;

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
    packages = packageList;
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PNPM_HOME = "$HOME/.pnpm-global";
    };

    # ## DONT CHANGE THIS LINE!
    stateVersion = "25.05";
  };

  # Packages configurable via home manager config settings
  imports = [
    # sway
    (import ../../../programs/homeManager/sway/default.nix {
      inherit inputConfig;
      inherit outputConfig;
      inherit extraConfig;
      inherit startupConfig;
      inherit pkgs;
    })

    # sagemath
    #(import ../../../programs/homeManager/sagemath/default.nix)

    # Go
    (import ../../../programs/homeManager/go/default.nix)

    # fish
    (import ../../../programs/homeManager/fish/default.nix { inherit pkgs; })

    # nvim
    (import ../../../programs/homeManager/neovim/default.nix { inherit pkgs; })

    # git
    (import ../../../programs/homeManager/git/default.nix { user = gitUser; })

    # vscode
    (import ../../../programs/homeManager/vscode/default.nix { inherit pkgs; inherit lib; })

    # bash
    (import ../../../programs/homeManager/bash/default.nix)

    # firefox
    (import ../../../programs/homeManager/firefox/default.nix { inherit pkgs; inherit lib; })

    # kitty
    (import ../../../programs/homeManager/kitty/default.nix)

    # waybar
    (import ../../../programs/homeManager/waybar/default.nix)

    # wofi
    (import ../../../programs/homeManager/wofi/default.nix)

    # direnv
    (import ../../../programs/homeManager/direnv/default.nix)

    # thunderbird
    (import ../../../programs/homeManager/thunderbird/default.nix)

    # texlive
    (import ../../../programs/homeManager/texlive/default.nix)

    # anki
    (import ../../../programs/homeManager/anki/default.nix)
  ];

  programs.home-manager.enable = true;
}




