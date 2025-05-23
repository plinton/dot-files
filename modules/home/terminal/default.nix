{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.plinton.terminal;
in {
  options.plinton.terminal = {
    enable = lib.mkEnableOption "Enable plinton.terminal";
    prompt = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "starship"
          "oh-my-posh"
        ]
      );
      
      default = null;
      description = "The prompt engine to use";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      delta
      fd
      aider-chat
      comma
    ];

    home.sessionVariables = {
      OLLAMA_API_BASE = "http://127.0.0.1:11434";
      AIDER_AUTO_COMMITS = "false";
      AIDER_MODEL = "ollama_chat/qwen2.5-coder";
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
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        pull.rebase = true;
        rebase = {
          autoSquash = true;
          autoStash = true;
          updateRefs = true;
        };
        fetch = {
          prune = true;
          pruneTags = true;
          all = true;
        };
        merge.conflictStyle = "zdiff3";
        rerere.enabled = true;
        diff = {
          algorithm = "histogram";
          colorMoved = true;
          mnemonicPrefix = true;
          renames = true;
        };
        branch.sort = "committerdate";
        tag.sort = "taggerdate";
      };
      ignores = [
        ".aider*"
        ".env"
        ".direnv"
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
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f";
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = ["--preview 'head {}'"];
    };
    programs.oh-my-posh = lib.mkIf (cfg.prompt == "oh-my-posh") {
      enable = true;
      enableZshIntegration = true;
      useTheme = "catppuccin_mocha";
    };
    programs.starship = lib.mkIf (cfg.prompt == "starship") {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        line_break = {
          disabled = true;
        };
        format = lib.concatStrings [
          "$directory"
          "$fossil_branch"
          "$fossil_metrics"
          "$git_branch"
          "$git_commit"
          "$git_state"
          "$git_metrics"
          "$git_status"
          "$hg_branch"
          "$pijul_channel"
          "$nix_shell"
          "$jobs"
          "$sudo"
          "$cmd_duration"
          "$character"
        ];
        directory = {
          style = "bold lavender";
          truncate_to_repo = true;
        };
        character = {
          success_symbol = "[❯](bold sapphire)";
          error_symbol = "[❯](bold rosewater)";
        };
      };
    };
  };
}
