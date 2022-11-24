{ config, pkgs, nixpkgs, ... }:

{

  imports = [
    ./terminal.nix
    ./neovim.nix
  ];
  home.username = "spin";
  home.homeDirectory = "/home/spin";


  home.stateVersion = "21.05";
  programs.zsh.initExtra =
   ''
   source /etc/zsh/zshrc.default.inc.zsh
   '';
}
