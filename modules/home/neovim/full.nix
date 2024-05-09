{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
  ];
  programs.neovim.plugins = with pkgs.vimPlugins; [
    nvim-treesitter.withAllGrammars
  ];
}
