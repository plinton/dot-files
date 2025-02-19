{
  config,
  lib,
  pkgs,
  homebrew,
  ...
}: let
  cfg = config.plinton.wezterm;
in {
  options = {
    plinton.wezterm = {
      enable = lib.mkEnableOption "Install and configure wezterm";

      use_homebrew = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "use homebrew to install wezterm";
      };
    };
  };

  config = lib.mkIf (cfg.enable && cfg.use_homebrew) {
    homebrew = {
      casks = [
        "wezterm"
      ];
    };
  };
}
