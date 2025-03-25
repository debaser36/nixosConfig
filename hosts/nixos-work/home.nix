{ pkgs,...}:
{
	home.username = "nico";
	home.homeDirectory = "/home/nico";
	home.packages = with pkgs; [

		isabelle
		
		bruno
		element-desktop

		neofetch
		nnn
		#firefox
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

	home.sessionVariables = {
		WLR_RENDERER_ALLOW_SOFTWARE="1";
     WLR_EVDI_RENDER_DEVICE = "/dev/dri/card1"; 
		};
	

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
		
 	
	# WAYLAND
	wayland.windowManager.sway = {
		checkConfig = false;
		enable = true;
		wrapperFeatures.gtk = true;
		config = {
			modifier = "Mod4";
			menu = "wofi --show run";
			bars = [
				{
					command = "waybar";
				}
			];
			terminal = "alacritty";
			window = {
				border = 5;
			};
			colors = {
				focused.border = "#6ea5ff";
				focused.background = "#367ff5";
				focused.childBorder = "#2878fa";
				focused.indicator = "#2878fa";
				focused.text = "#ffffff";
				unfocused.border = "a1fff7";
				unfocused.background = "#0061fc";
				unfocused.childBorder = "#1770ff";
				unfocused.indicator = "#1df5e3";
				unfocused.text = "#dcdede";
			};
			output."*".bg = "/etc/default_wallpaper.jpg fill";
			output = {
				DVI-I-3 = {
					position = "0,0";
				};
				eDP-1 = {
					position = "1920,0";
				};
				DVI-I-4 = {
					position = "3840,0";
				};
    		};
			input = {
				"*" = {xkb_layout = "de";};
			};
		};
		extraConfig = ''
			bindsym Print			exec shotman -c output
			bindsym Print+Shift		exec shotman -c region
			bindsym Print+Shift+Control	exec shotman -c window
		'';
		extraOptions = ["--unsupported-gpu"];
  	};

		programs.waybar = {
			enable = true;
			settings = [{
				"layer"="top";
				"modules-left"= ["sway/workspaces" "sway/mode"];
				"modules-center" = ["sway/window"];
				"modules-right" = [ "clock"];
				"clock" = {
					"format-alt"= "{:%a, %d. %b  %H:%M}";
				};
			}];
		};
	

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




