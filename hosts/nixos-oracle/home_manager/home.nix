_:
let
  vars = import ../vars.nix;
in
{
  imports = [
    ./home_packagelist.nix

    # firefox
    ../../../programs/homeManager/firefox/default.nix

    # nvim
    ../../../programs/homeManager/neovim/default.nix

    # fish
    ../../../programs/homeManager/fish/default.nix
  ];

  programs = {
    git = {
      enable = true;
      settings.user.name = "debaser36";
      settings.user.email = "n.burkholder@tu-berlin.de";
    };
    home-manager.enable = true;
  };

  home = {
    inherit (vars.default_user) username;
    homeDirectory = vars.default_user.home;
    # don't change these Lines!!!
    stateVersion = "24.11";
  };
}
