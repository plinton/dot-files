{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    delta
    bat
    fd
    fastmod
  ];

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
    fileWidgetCommand = "fd --type f";
    fileWidgetOptions = [ "--preview 'head {}'"];
  };
}
