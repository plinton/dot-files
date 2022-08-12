{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kmix
    xclip
    skanlite
  ];
  programs.zsh = {
    shellAliases = {
      pbcopy = "xclip -selection clipboard";
      pbpaste = "xclip -selection clipboard -o";
    };
  };
}
