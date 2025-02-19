{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.plinton.raycast;
in {
  options.plinton.raycast = {
    enable = lib.mkEnableOption "Enable Raycast";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      raycast
    ];
  };
}
