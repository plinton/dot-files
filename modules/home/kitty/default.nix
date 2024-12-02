{ config, pkgs, lib, ... }:
let cfg = config.plinton.kitty;
in {
  options.plinton.kitty = {
    enable = lib.mkEnableOption "enable kitty with config";
  };
  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    programs.kitty = {
      enable = true;
      settings = {
        shell = "zsh";
      };
      font = {
        package = pkgs.nerd-fonts.droid-sans-mono;
        name = "DroidSansM Nerd Font Mono";
        size = 12;
      };
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
    };
  };
}
