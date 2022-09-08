{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    delta
    bat
    fd
    fastmod
    jq
    rq
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.git = {
    enable = true;
    delta = {
      enable = true;
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
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
}
