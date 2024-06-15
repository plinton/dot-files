{ pkgs, lib, ... }:
let cfg = config.plinton.kde;
in
{
  options.plinton.kde = {
    enable = mkEnableOption "KDE Plasma Desktop";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      kmix
      xclip
      skanlite
    ];
    programs.zsh = {
      shellAliases = {
        pbcopy = "xclip -selection clipboard";
        pbpaste = "xclip -selection clipboard -o";
      };
    };
  };
}
