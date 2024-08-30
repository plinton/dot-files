{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib) types;

  cfg = config.plinton.wezterm;
in
{
  options = {
    plinton.wezterm = {
      enable = lib.mkEnableOption (
        "configure wezterm"
      );
    };
  };

  config = lib.mkIf cfg.enable {
    home.file.".config/wezterm/wezterm.lua".source = ./wezterm.lua;
  };
}
