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
    # EDITOR and VISUAL come from programs.neovim.defaultEditor
    sessionVariables = {
      PNPM_HOME = "$HOME/.pnpm-global";
    };
  };

  imports = [
    ./packages.nix
    ./sway.nix
    ../../homeManager/swayosd/default.nix
    ./ssh.home.nix
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

  services.udiskie.enable = true;
  xdg.enable = true;
  programs = {
    home-manager.enable = true;
    # Runs the script from the checkout, which it needs to find the repository
    fish.shellAliases.nixConfigConfigurator = "~/nixosConfig/programs/tools/nixos_manager/nixosmanager.fish";
  };
}
