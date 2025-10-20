{
  # git diff colors i think
  programs.delta ={
    enable = true;
    enableGitIntegration = true;
  };

  # enable git with my name and email
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Soep";
        email = "soep@tuta.io";
      };
      core.editor = "nvim -c 'vsplit term://git --no-pager diff --cached | wincmd h'";
      init.defaultBranch = "main";
      pull.rebase = true;
      safe.directory = "/etc/nixos";
    };
  };
}
