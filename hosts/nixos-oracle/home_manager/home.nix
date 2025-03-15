{config, pkgs,...}:
let
	vars = import ./vars.nix;
	gitUser = import ../../../programSettings/git/tu-berlin/user.nix;
in
{
	imports = [

		(import./home_packagelist.nix{
			pkgs = pkgs;
		})
		(import ../../../programs/homeManager/git/default.nix {
			user = gitUser;
		})
		../../../programs/homeManager/bash/default.nix
		../../../programs/homeManager/neovim/default.nix
	];

	home.username = vars.default_user.username;
	home.homeDirectory = vars.default_user.home;
	
	# don't change these Lines!!!
	home.stateVersion = "24.11";
	programs.home-manager.enable = true;
}




