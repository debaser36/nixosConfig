{ pkgs, lib, ... }:
let
  vars = import ../vars.nix;
in
{
  imports = [
    (import ./home_packagelist.nix {
      inherit pkgs;
    })

    # firefox
    (import ../../../programs/homeManager/firefox/default.nix { inherit pkgs; inherit lib; })

    # nvim
    (import ../../../programs/homeManager/neovim/default.nix { inherit pkgs; })

    # fish
    (import ../../../programs/homeManager/fish/default.nix { inherit pkgs; inherit lib; })
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
