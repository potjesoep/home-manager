{pkgs, ...}:

{
  # enable fish with starship and colored command output
  programs.fish = {
    enable = true;
    plugins = [
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages.src; }
    ];
    shellAliases = {
      nfu = "git pull && nix flake update && git add . && git commit -m 'chore: update nix flake' && git push";
      hr = "home-manager switch --flake .#cuddles";
      sr = "sudo nixos-rebuild switch";
    };
  };
}
