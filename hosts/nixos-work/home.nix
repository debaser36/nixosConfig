{ pkgs,...}:
{
	home.username = "nico";
	home.homeDirectory = "/home/nico";
	home.packages = with pkgs; [

		isabelle
		
		bruno
		element-desktop

		sqlite


		neofetch
		nnn
		thunderbird

		swaylock
		swayidle
		mako
		waybar

		# archives
		zip
		xz
		unzip
		p7zip

		#utils
		jq
		yq-go

		#network
		mtr
		iperf3
		dnsutils
		ldns
		aria2
		socat
		nmap
		ipcalc
		
		#misc
		which
		tree
		gnused
		zstd
		gnupg
		libnotify
		kitty # terminal emulator
		alacritty
		keepassxc
		mako 
		wl-clipboard
		shotman

		#nix-related
		nix-output-monitor
		
		#systools
		xorg.xmodmap
		sysstat
		lm_sensors
		ethtool
		pciutils
		usbutils
		xorg.xrandr
		wlroots

		#gaming
		steam

		#other
		nil
	];

	
	

	# GIT
	programs.git = {
		enable = true;
		userName = "debaser36";
		userEmail = "n.burkholder@tu-berlin.de";	
	};

	# FIREFOX
	programs.firefox = {
		enable = true;
		profiles."nico" = {
			#extensions.packages
		};

	};

	imports = [
			(import ../../programs/homeManager/sway/default.nix {
				outputConfig = {
					# monitor on the left
					output.HDMI-A-1 = {
						mode="1920x1200@59.950Hz";
						position="0,0";
						transform="90";
					};

					# laptop center
					output.eDP-1 = {
						mode="1920x1200@60.002Hz";
						position="1200,240";
					};

					# monitor on the right
					output.DP-2 = {
						mode="2560x1440@59.951Hz";
						position="3120,120";
					};
				};
			})
	];
		

			
	

	# BEVLOED NVIM
  	programs.neovim = {
      		enable = true;
      		defaultEditor = true;
					withNodeJs = true;
      		viAlias = true;
					vimAlias = true;
      		vimdiffAlias = true;
					plugins = with pkgs.vimPlugins; [
						nvim-lspconfig
						nvim-treesitter.withAllGrammars
						plenary-nvim
						gruvbox-material
						mini-nvim
					];
	      	extraConfig = ''
						set tabstop=2
						set softtabstop=2
						set shiftwidth=2
						set autoindent
						set number
						set wildmode=longest,list
						set cc=80
						filetype plugin indent on
						syntax on
						set clipboard=unnamedplus
						set mouse=a
						filetype plugin on
						set cursorline
						set ttyfast
			'';
		  };
		
		 programs.vscode = {
				enable = true;
				extensions = with pkgs.vscode-extensions; [
				# TypeScript/JavaScript/Node Development
				esbenp.prettier-vscode            # Code formatting
				christian-kohler.npm-intellisense # NPM intellisense
				prisma.prisma                     # Prisma ORM support
				
				
				# Nix Language Support
				bbenoist.nix                      # Nix language syntax highlighting
				jnoortheen.nix-ide                # Enhanced Nix IDE features
				arrterian.nix-env-selector        # Nix environment selector

			];

			userSettings = {
      			"nix.enableLanguageServer" = true;
      			"nix.serverPath" = "nil";

      			
				"nix.serverSettings" = {
      				"nil" = {
        			"formatting" = {
        			  "command" = [ "nixfmt" ];
        			};
      			};
    		};
			};
		 };
		 
		#-------------Bash settings------------
		programs.bash.enable = true;
		
		programs.bash.shellAliases = {
			ll = "ls -l";
			la = "ls -A";
			ls = "ls -A --color=tty";
		};
		programs.bash.bashrcExtra = "export PATH=\"$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin\"";
		programs.kitty.enable = true;

		programs.alacritty.enable = true;


		# don't change these Lines!!!
		home.stateVersion = "24.11";
		programs.home-manager.enable = true;
	}




