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
      use_homebrew = lib.mkOption ({
        type = lib.types.bool;
        default = false;
        description = "use homebrew to install wezterm";
      });
    };
  };

  config = lib.mkIf cfg.enable {
    programs.wezterm.enable = cfg.enable && !cfg.use_homebrew;
    home.file.".config/wezterm/wezterm.lua".source = ./wezterm.lua;
  };
}
