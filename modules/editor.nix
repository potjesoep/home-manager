{pkgs, ...}:

{
  # enable neovim and set it as the default editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      "Set to habamax colorscheme
      colorscheme habamax

      "Split to right/below instead of left/up by default
      set splitright
      set splitbelow

      "Hybrid line numbers and ruler
      set number
      set relativenumber
      set ruler

      "Activate automatic indentation
      filetype off
      filetype plugin indent on
      set smartindent
      set autoindent

      "Non-expanded, 4-wide tabulations
      set tabstop=4
      set shiftwidth=4
      set noexpandtab

      "Real-world encoding
      set encoding=utf-8

      "Interpret modelines in files
      set modelines=1

      "Do not abandon buffers
      set hidden

      "More useful backspace behavior
      set backspace=indent,eol,start

      "Use statusbar on all windows
      set laststatus=2

      "Better search
      set ignorecase
      set smartcase
      set incsearch
      set showmatch
      set hlsearch

      "Break at word instead of character
      set linebreak

      "Save undo history to file
      set undofile
      set undodir=$HOME/.config/nvim/undo
      set undolevels=1000
      set undoreload=10000

      "Auto Generate PDF on saving briefje
      autocmd BufWritePost */briefjes/*.md !./convert.fish %

      "Simple workman remap from: https://axiomatic.neophilus.net/workman-layout-for-vim/
      nnoremap l o
      nnoremap o l
      nnoremap L O
      nnoremap O L
      nnoremap j n
      nnoremap n j
      nnoremap J N
      nnoremap N J
      nnoremap gn gj
      nnoremap gj gn
      nnoremap k e
      nnoremap e k
      nnoremap K E
      nnoremap E <nop>
      nnoremap gk ge
      nnoremap ge gk
      nnoremap h y
      onoremap h y
      nnoremap y h
      nnoremap H Y
      nnoremap Y H
    '';
    plugins = with pkgs.vimPlugins; [
      auto-save-nvim
      nerdtree-git-plugin
      vim-nerdtree-syntax-highlight
      vim-nerdtree-tabs
      {
        plugin = nerdtree;
        config = ''
          " Start NERDTree. If a file is specified, move the cursor to its window.
          autocmd StdinReadPre * let s:std_in=1
          autocmd VimEnter * NERDTree | if argc() > 0 && !isdirectory(argv()[0]) || exists("s:std_in") | wincmd p | endif
          " Start NERDTree when Vim starts with a directory argument.
          autocmd StdinReadPre * let s:std_in=1
          autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') | execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif
          " Exit Vim if NERDTree is the only window remaining in the only tab.
          autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
          " Close the tab if NERDTree is the only window remaining in it.
          autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
        '';
      }
      {
        plugin = telescope-nvim;
        config = ''
          "Set leader key
          let mapleader = ","

          " Find files using Telescope command-line sugar.
          nnoremap <leader>ff <cmd>Telescope find_files<cr>
          nnoremap <leader>fg <cmd>Telescope live_grep<cr>
          nnoremap <leader>fb <cmd>Telescope buffers<cr>
          nnoremap <leader>fh <cmd>Telescope help_tags<cr>
        '';
      }
      coq-artifacts
      coq-thirdparty
      nvim-lspconfig
      {
        plugin = coq_nvim;
        config = ''
          lua << EOF
            vim.g.coq_settings = {
              auto_start = 'shut-up',
              xdg = true,
            }
            local lsp = require "lspconfig"
            local coq = require "coq"

            lsp.hls.setup(coq.lsp_ensure_capabilities())
          EOF
        '';
      }
      vim-nix
      render-markdown-nvim
      {
        plugin = csvview-nvim;
        config = ''
          lua << EOF
            local csv = require("csvview")

            csv:setup({
              parser = {
                async_chunksize = 50,

                delimiter = {
                  default = ",",
                  ft = {
                    tsv = "\t",
                  },
                },

                quote_char = '"',

                comments = {
                  "#",
                  "--",
                  "//",
                },
              },
              view = {
                min_column_width = 1,
                spacing = 0,
                display_mode = "border",
                header_lnum = 1,

                sticky_header = {
                  enabled = true,
                  separator = "─",
                },
              },

              keymaps = {},

              actions = {
              },
            })
          EOF
        '';
      }
      {
        plugin = markdown-preview-nvim;
        #config = ''
        #  autocmd BufEnter *.md MarkdownPreview
        #'';
      }
    ];
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
  programs.helix.enable = true;
}
