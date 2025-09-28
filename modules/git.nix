{
  # enable git with my name and email
  programs.git = {
    enable = true;
    delta.enable = true;
    userName = "Soep";
    userEmail = "soep@tuta.io";
    extraConfig = {
      core.editor = "nvim -c 'vsplit term://git --no-pager diff --cached | wincmd h'";
      init.defaultBranch = "main";
      pull.rebase = true;
      safe.directory = "/etc/nixos";
    };
  };
}
