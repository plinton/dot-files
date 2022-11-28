{ config, pkgs, nixpkgs, lib, ... }:
let
  linux_only_pkgs = with pkgs; [
    tdesktop
  ];
  common_pkgs = with pkgs; [
    zoom-us
    lastpass-cli
    spotify-tui
    spotifyd
  ];
in
{
  imports = [
    ./terminal.nix
    ./kitty.nix
    ./neovim.nix
  ];

  programs.git = {
    userName = "Paul Ellis Linton";
    userEmail = "plinton@musicalcomputer.com";
  };
  # this symlinks the apps, which spotlight won't follow. Seed below
  disabledModules = [ "targets/darwin/linkapps.nix" ];

  # try to get system packages into Applications
  # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1190875080
  home.activation = lib.mkIf pkgs.stdenv.isDarwin {
    copyApplications =
      let
        apps = pkgs.buildEnv {
          name = "home-manager-applications";
          paths = config.home.packages;
          pathsToLink = "/Applications";
        };
      in
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        baseDir="$HOME/Applications/Home Manager Apps"
        if [ -d "$baseDir" ]; then
          rm -rf "$baseDir"
        fi
        mkdir -p "$baseDir"
        for appFile in ${apps}/Applications/*; do
          target="$baseDir/$(basename "$appFile")"
          $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
          $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
        done
      '';
  };

  # N.B. The user will be defined in the flake

  home.packages =
    if pkgs.stdenv.isDarwin
    then common_pkgs
    else linux_only_pkgs ++ common_pkgs;

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      line_break = {
        disabled = true;
      };
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
