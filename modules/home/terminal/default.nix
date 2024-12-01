{ config, pkgs, lib, ... }:
let cfg = config.plinton.terminal;
in
{
  options.plinton.terminal = {
    enable = lib.mkEnableOption "Enable plinton.terminal";
    starship = lib.mkEnableOption "Enable starship";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      delta
      fd
      aider-chat
    ];

    home.sessionVariables = {
      OLLAMA_API_BASE = "http://127.0.0.1:11434";
      AIDER_AUTO_COMMITS = "false";
      AIDER_MODEL = "ollama_chat/llama3.2";
      AIDER_MAP_TOKENS = "1024";
      AIDER_CHECK_UPDATE = "false";
      AIDER_GITIGNORE = "false";
    };

    programs.git = {
      enable = true;
      delta = {
        enable = true;
      };
      extraConfig = {
        init.defaultBranch = "main";
        push.default = "current";
        pull.rebase = true;
        rebase = {
          autoSquash = true;
          autoStash = true;
          updateRefs = true;
        };
        merge.conflictStyle = "zdiff3";
        rerere.enabled = true;
        diff.algorithm = "histogram";
        branch.sort = "committerdate";
        tag.sort = "taggerdate";
      };
      ignores = [
        ".aider*"
        ".env"
      ];
    };
    programs.jq = {
      enable = true;
    };
    programs.bat = {
      enable = true;
    };
    programs.ripgrep = {
      enable = true;
    };

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting = {
        enable = true;
      };
    };

    programs.lsd = {
      enable = true;
      enableAliases = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f";
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = [ "--preview 'head {}'" ];
    };
    programs.starship = lib.mkIf cfg.starship {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        line_break = {
          disabled = true;
        };
      };
    };
  };
}
