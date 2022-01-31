{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    delta
    bat
    git
    fzf
    fd
    procs
    yq-go
    jq
    sd
    fastmod
    xsv
    nnn
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
}
