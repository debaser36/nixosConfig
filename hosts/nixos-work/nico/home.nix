{ pkgs,lib, ...}:
let 
# sway
		outputConfig = (import ../hardware/swayMonitorSettings.nix);
		inputConfig = (import ../hardware/swayInputSettings.nix);
		extraConfig = (import ./swayExtraConfig.nix);
		startupConfig = (import ./swayStartup.nix);
#/sway

		packageList = (import ./packageList.nix {inherit pkgs;});
		
		gitUser = {
			username = "debaser36";
			email = "n.burkholder@tu-berlin.de";
		};
in
{
	home.username = "nico";
	home.homeDirectory = "/home/nico";
	home.sessionPath = [
			"$HOME/bin"
			"$HOME/.pnpm-global"
			"$HOME/.npm-global/bin"
			"$HOME/.local/bin"
			"$HOME/go/bin"
	];

	# Packages not configurable via home manager config settings
	home.packages = packageList;
	home.sessionVariables = {
		EDITOR = "nvim";
		VISUAL = "nvim";
		PNPM_HOME = "$HOME/.pnpm-global";

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

			# fish
			(import ../../../programs/homeManager/fish/default.nix {inherit pkgs;})

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

			# thunderbird
			(import ../../../programs/homeManager/thunderbird/default.nix)
	];

		# don't change these Lines!!!
		home.stateVersion = "25.05";
		programs.home-manager.enable = true;
	}




