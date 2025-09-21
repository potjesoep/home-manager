{
  # terminal utils
  programs.bat.enable = true;
  programs.btop.enable = true;
  programs.eza.enable = true;
  programs.fd.enable = true;
  programs.fzf.enable = true;
  programs.jq.enable = true;
  programs.ripgrep.enable = true;
  programs.starship.enable = true;
  programs.zoxide.enable = true;

  # enable nix-index for nix-locate files from nixpkgs
  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;
}
