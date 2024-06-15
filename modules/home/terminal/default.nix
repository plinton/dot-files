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
    ];

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
    };
    programs.jq = {
      enable = true;
    };
    programs.bat = {
      enable = true;
      config = {
        theme = "catppuccin";
      };
      themes = {
        catppuccin = {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
            sha256 = "6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
          };
          file = "Catppuccin-mocha.tmTheme";
        };
      };

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
      defaultOptions = [
        "--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284"
        "--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf"
        "--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"
      ];
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
