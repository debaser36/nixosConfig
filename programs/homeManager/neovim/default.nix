{pkgs, ...}:
{
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
  }