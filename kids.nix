{ config, pkgs, nixpkgs, ... }:

{
  home.packages = with pkgs; [
    nsnake
  ];
  programs.zsh = {
    initExtra = "autoload -Uz tetriscurses";
  };
}
