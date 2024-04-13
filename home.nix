{ config, pkgs, nixpkgs, lib, ... }:
let
  linux_only_pkgs = with pkgs; [
    tdesktop
  ];
  darwin_only_pkgs = with pkgs; [
    iina
  ];
  common_pkgs = with pkgs; [
    lastpass-cli
    (nerdfonts.override { fonts = [ "DroidSansMono" ]; })
  ];
in
{
  imports = [
    ./modules/terminal.nix
    ./modules/kitty.nix
    ./modules/neovim/full.nix
    ./modules/kids.nix
    ./modules/raycast.nix
  ];

  programs.git = {
    userName = "Paul Ellis Linton";
    userEmail = "plinton@musicalcomputer.com";
  };

  fonts.fontconfig.enable = true;

  # N.B. The user will be defined in the flake

  home.packages =
    if pkgs.stdenv.isDarwin
    then common_pkgs ++ darwin_only_pkgs
    else linux_only_pkgs ++ common_pkgs;

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      line_break = {
        disabled = true;
      };
    };
  };

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
