{ config, pkgs, nixpkgs, ... }:

{
  home.packages = with pkgs; [
    nsnake
  ];
}
