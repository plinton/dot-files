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

    programs.wezterm = lib.mkIf (!cfg.use_homebrew) {
      enable = true;
      extraConfig = builtins.readFile ./wezterm.lua;
      enableZshIntegration = true;
    };
    home.file.".config/wezterm/wezterm.lua" = lib.mkIf cfg.use_homebrew {
      source = ./wezterm.lua;
    };
  };
}
