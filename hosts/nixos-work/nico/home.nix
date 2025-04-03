{ pkgs,lib, ...}:
let 
		outputConfig = (import ../hardware/swayMonitorSettings.nix);
		packageList = (import ./packageList.nix {inherit pkgs;});
		
		gitUser = {
			username = "debaser36";
			email = "n.burkholder@tu-berlin.de";
		};
in
{
	home.username = "nico";
	home.homeDirectory = "/home/nico";

	# Packages not configurable via home manager config settings
	home.packages = packageList;

	# Packages configurable via home manager config settings
	imports = [
			# sway
			(import ../../../programs/homeManager/sway/default.nix {
				inherit outputConfig;
				inherit pkgs;
			})

			# nvim
			(import ../../../programs/homeManager/neovim/default.nix {inherit pkgs;})

			# git
			(import ../../../programs/homeManager/git/default.nix {user = gitUser;})

			# vscode
			(import ../../../programs/homeManager/vscode/default.nix {inherit pkgs; inherit lib;})

			# bash
			(import ../../../programs/homeManager/bash/default.nix)

			# firefox
			(import ../../../programs/homeManager/firefox/default.nix {inherit pkgs; inherit lib;})

			# kitty
			(import ../../../programs/homeManager/kitty/default.nix)

			# waybar
			(import ../../../programs/homeManager/waybar/default.nix)
		
			# wofi
			(import ../../../programs/homeManager/wofi/default.nix)

			# direnv
			(import ../../../programs/homeManager/direnv/default.nix)

			# discord
			(import ../../../programs/homeManager/discord/default.nix)
	];

		# don't change these Lines!!!
		home.stateVersion = "25.05";
		programs.home-manager.enable = true;
	}




