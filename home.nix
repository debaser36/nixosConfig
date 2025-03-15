{config, pkgs,...}:
{
	home.username = "nico";
	home.homeDirectory = "/home/nico";
	home.packages = with pkgs; [
		neofetch
		nnn
		
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
		openssl		
		#misc
		which
		tree
		gnused
		zstd
		gnupg
		libnotify
		kitty

		#nix-related
		nix-output-monitor
		
		#systools
		sysstat
		lm_sensors
		ethtool
		pciutils
		usbutils
		xorg.xrandr
	];

	

	# GIT
	programs.git = {
		enable = true;
		userName = "debaser36";
		userEmail = "n.burkholder@tu-berlin.de";	
	};
		
  # BEVLOED NVIM
  programs.neovim = {
      enable = true;
      defaultEditor = true;
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
	
	 
	#-------------Bash settings------------
	programs.bash.enable = true;
	programs.bash.shellAliases = {
		ll = "ls -l";
		la = "ls -A";
		ls = "ls -A --color=tty";
	};
	programs.bash.bashrcExtra = "export PATH=\"$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin\"";
	

	# don't change these Lines!!!
	home.stateVersion = "24.11";
	programs.home-manager.enable = true;
}




