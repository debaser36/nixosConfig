{config, pkgs,...}:
let
	vars = import ../vars.nix;
	gitUser = import ../../../programSettings/git/tu-berlin/user.nix;
in
{
	imports = [

		(import ./home_packagelist.nix{
			pkgs = pkgs;
		})
	];

	programs.git.enable = true;
  programs.git.userName = "debaser36";
  programs.git.userEmail = "n.burkholder@tu-berlin.de";


	programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        plugins =  [
          pkgs.vimPlugins.nvim-lspconfig
          pkgs.vimPlugins.nvim-treesitter.withAllGrammars
          pkgs.vimPlugins.plenary-nvim
          pkgs.vimPlugins.gruvbox-material
          pkgs.vimPlugins.mini-nvim
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


	home.username = vars.default_user.username;
	home.homeDirectory = vars.default_user.home;
	
	# don't change these Lines!!!
	home.stateVersion = "24.11";
	programs.home-manager.enable = true;
}