{ config
, lib
, pkgs
, homebrew
, ...
}:
let
  inherit (lib) types;

  cfg = config.plinton.services.ollama;
in
{
  options = {
    plinton.services.ollama = {
      enable = lib.mkEnableOption (
        "Server for local large language models"
      );
    };
  };

  config = lib.mkIf cfg.enable {
    homebrew = {
      brews = [
        {
          name = "ollama";
          start_service = true;
          restart_service = "changed";
        }
      ];
    };
  };
}
