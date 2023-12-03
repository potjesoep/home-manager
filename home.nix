{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "cuddles";
  home.homeDirectory = "/home/cuddles";

  # enable fish with starship and colored command output
  programs.fish = {
    enable = true;
    plugins = [
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages.src; }
    ];
  };

  # terminal utils
  programs.bat.enable = true;
  programs.btop.enable = true;
  programs.eza.enable = true;
  programs.fzf.enable = true;
  programs.ripgrep.enable = true;
  programs.starship.enable = true;
  programs.zoxide.enable = true;

  # enable nix-index for nix-locate files from nixpkgs
  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;

  # enable git with my name and email
  programs.git = {
    enable = true;
    delta.enable = true;
    userName = "Mia Winter Schat";
    userEmail = "nekonoor@proton.me";
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
    };
  };

  # enable neovim and set it as the default editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
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
    '';
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nerdtree;
        config = ''
          " Start NERDTree. If a file is specified, move the cursor to its window.
          autocmd StdinReadPre * let s:std_in=1
          autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
          " Exit Vim if NERDTree is the only window remaining in the only tab.
          autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
          " Close the tab if NERDTree is the only window remaining in it.
          autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
        '';
      }
      nerdtree-git-plugin
      vim-nerdtree-syntax-highlight
      vim-nerdtree-tabs
      vim-nix
    ];
  };
  programs.helix.enable = true;

  # autoconnect virt-manager to qemu
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/cuddles/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
    fish_greeting = "";
    fish_prompt_pwd_dir_length = 0;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
