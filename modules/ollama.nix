{ config
, lib
, pkgs
, homebrew
, ...
}:
let
  inherit (lib) types;

  cfg = config.services.ollama;
in
{
  options = {
    services.ollama = {
      enable = lib.mkEnableOption (
        "Server for local large language models"
      );
      package = lib.mkPackageOption pkgs "ollama" { };
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
