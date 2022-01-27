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
}
