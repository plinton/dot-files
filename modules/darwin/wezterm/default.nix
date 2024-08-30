{ config
, lib
, pkgs
, homebrew
, ...
}:
let
  cfg = config.plinton.wezterm;
in
{
  options = {
    plinton.wezterm = {
      enable = lib.mkEnableOption (
        "Install and configure wezterm"
      );
    };
  };

  config = lib.mkIf cfg.enable {
    homebrew = {
      casks = [
        "wezterm"
      ];
    };
  };
}
