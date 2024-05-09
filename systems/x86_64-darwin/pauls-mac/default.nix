{ config, pkgs, nixpkgs, ... }:

{
  users.users.paul.home = /Users/paul;

  imports = [
    ./../../../modules/darwin/ollama
  ];
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '';

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    brews = [
      "firefoxpwa"
    ];
    casks = [
      "psst"
    ];
  };

  programs.zsh.enable = true;

  services.ollama = {
    enable = true;
  };

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
