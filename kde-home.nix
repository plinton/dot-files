{ config, pkgs, nixpkgs, ... }:

{
  # Let Home Manager install and manage itself.
  #programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  imports = [ ./terminal.nix ./kitty.nix ./neovim/full.nix ./kde.nix ];
  nixpkgs.config.allowUnfree = true;
  home.username = "paul";
  home.homeDirectory = "/home/paul";
  home.packages = with pkgs; [
    tdesktop
    zoom-us
    teams
    bind
    lastpass-cli
    spotify-tui
    spotifyd
  ];

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
