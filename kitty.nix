{ config, pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      shell = "zsh";
    };
  };
}
