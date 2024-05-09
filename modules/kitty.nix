{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "DroidSansMono" ]; })
  ];
  fonts.fontconfig.enable = true;
  programs.kitty = {
    enable = true;
    settings = {
      shell = "zsh";
    };
    font.name = "DroidSansMono";
    font.size = 12;
    darwinLaunchOptions = [ "--single-instance" ];
    shellIntegration = {
      enableZshIntegration = true;
    };
    keybindings = {
      "ctrl+shift+>" = "next_window";
      "ctrl+shift+<" = "previous_window";
    };
    settings = {
      tab_bar_style = "powerline";
    };
    extraConfig = builtins.readFile (pkgs.fetchFromGitHub
      {
        owner = "catppuccin";
        repo = "kitty";
        rev = "ad38e5bb1b1ab04e7d2cf86ded289c455df62908";
        sha256 = "0vb5fkpxjyyj180wfc948c1qvndlcwv0mzmz0xdv7wdg7qj9v7hk";
      } + "/mocha.conf");
  };
}
