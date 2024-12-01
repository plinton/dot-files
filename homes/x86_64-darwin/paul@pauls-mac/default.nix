{ config, pkgs, lib, nixvim, catppuccin, ... }:
{
  imports = [
    nixvim.homeManagerModules.nixvim
    catppuccin.homeManagerModules.catppuccin
    ./../../../modules/home/terminal
    ./../../../modules/home/kitty
    ./../../../modules/home/neovim
    ./../../../modules/home/kids
    ./../../../modules/home/raycast
    ./../../../modules/home/wezterm
  ];

  programs.git = {
    userName = "Paul Ellis Linton";
    userEmail = "plinton@musicalcomputer.com";
  };
  plinton.kitty.enable = true;
  plinton.wezterm = {
    enable = true;
    use_homebrew = true;
  };
  plinton.kids.enable = true;
  plinton.terminal = {
    enable = true;
    prompt = "oh-my-posh";
  };
  plinton.neovim = {
    enable = true;
  };

  fonts.fontconfig.enable = true;

  catppuccin = {
    enable = true;
    accent = "sapphire";
    flavor = "mocha";
  };

  # N.B. The user will be defined in the flake

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
