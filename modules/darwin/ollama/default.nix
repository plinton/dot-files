{ config
, lib
, pkgs
, ...
}:
let
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
    environment.systemPackages = [ pkgs.ollama ];
    launchd.user.agents.ollama = {
      serviceConfig = {
        ProgramArguments = [
          "${pkgs.ollama}/bin/ollama"
          "serve"
        ];
        RunAtLoad = true;
        KeepAlive = true;
      };
    };
  };
}
