{ config, pkgs, lib, ... }:
let
in
{
  imports = [
    ./../../../modules/home/terminal
    ./../../../modules/home/kitty
    ./../../../modules/home/neovim
    ./../../../modules/home/kids
    ./../../../modules/home/raycast
  ];

  programs.git = {
    userName = "Paul Ellis Linton";
    userEmail = "plinton@musicalcomputer.com";
  };
  plinton.kitty.enable = true;
  plinton.kids.enable = true;
  plinton.terminal = {
    enable = true;
    starship = true;
  };
  plinton.neovim = {
    enable = true;
    fullGrammars = true;
  };

  fonts.fontconfig.enable = true;

  # N.B. The user will be defined in the flake

  home.packages = with pkgs; [
    lastpass-cli
    iina
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
