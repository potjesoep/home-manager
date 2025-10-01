{pkgs, ...}:

{
  # enable fish with starship and colored command output
  programs.fish = {
    enable = true;
    plugins = [
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages.src; }
    ];
    functions = {
      ap = "adb push $argv /sdcard/Download";
    };
    shellAliases = {
      fb = "fastboot boot";
      hr = "home-manager switch --flake .#cuddles";
      nfu = "git pull && nix flake update && git add . && git commit -m 'chore: update nix flake' && git push";
      rbs = "rb-scrobbler -f /run/media/cuddles/rockbox/.scrobbler.log -n delete-on-success -o +2";
      sr = "sudo nixos-rebuild switch";
    };
  };
}
