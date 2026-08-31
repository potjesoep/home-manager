{pkgs, ...}:

{
  # enable neovim and set it as the default editor
  programs.neovim = {
    enable = true;
    withPython3 = true;
    withRuby = true;
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
        type = "viml";
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
        type = "viml";
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
      nvim-lspconfig
      coc-json
      coc-pyright
      coc-rust-analyzer
      coc-clangd
      {
        plugin = coc-nvim;
        type = "lua";
        config = ''
          vim.g.coc_global_extensions = { 'coc-json', 'coc-pyright', 'coc-rust-analyzer', 'coc-clangd' }

          vim.opt.backup = false
          vim.opt.writebackup = false
          vim.opt.updatetime = 300
          vim.opt.signcolumn = 'yes'
          vim.opt.laststatus = 2
 
          -- Show coc.nvim status, including extension installation progress
          vim.opt.statusline:prepend('%{coc#status()}')
           
          local keyset = vim.keymap.set
          function _G.check_back_space()
            local col = vim.fn.col('.') - 1
            return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
          end
           
          -- Trigger completion with Tab and navigate the completion menu
          local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
          keyset('i', '<TAB>', 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
          keyset('i', '<S-TAB>', [[coc#pum#visible() ? coc#pum#prev(1) : "<C-h>"]], opts)
          keyset('i', '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : "<C-g>u<CR><c-r>=coc#on_enter()<CR>"', { silent = true, expr = true })
           
          -- Diagnostics and code navigation
          keyset('n', '[g', '<Plug>(coc-diagnostic-prev)', { silent = true })
          keyset('n', ']g', '<Plug>(coc-diagnostic-next)', { silent = true })
          keyset('n', 'gd', '<Plug>(coc-definition)', { silent = true })
          keyset('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
          keyset('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
          keyset('n', 'gr', '<Plug>(coc-references)', { silent = true })
          keyset('n', '<leader>rn', '<Plug>(coc-rename)', { silent = true })
        '';
      }
      vim-nix
      render-markdown-nvim
      {
        plugin = csvview-nvim;
        type = "lua";
        config = ''
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
