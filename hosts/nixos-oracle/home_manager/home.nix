{ pkgs, ... }:
let
  vars = import ../vars.nix;
in
{
  imports = [

    (import ./home_packagelist.nix {
      pkgs = pkgs;
    })

    # nvim
    (import ../../../programs/homeManager/neovim/default.nix { inherit pkgs; })
  ];

  programs.git.enable = true;
  programs.git.userName = "debaser36";
  programs.git.userEmail = "n.burkholder@tu-berlin.de";


  home.username = vars.default_user.username;
  home.homeDirectory = vars.default_user.home;

  # don't change these Lines!!!
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
