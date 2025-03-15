{
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
  }