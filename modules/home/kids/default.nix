{ config, pkgs, lib, ... }:
let cfg = config.plinton.kids;
in
{
  options.plinton.kids = {
    enable = lib.mkEnableOption "Enable plinton.kids";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nsnake
    ];
    programs.zsh = {
      initExtra = "autoload -Uz tetriscurses";
    };
  };
}
