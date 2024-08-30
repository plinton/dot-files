{ config, pkgs, ... }:

{
  users.users.paul.home = /Users/paul;

  imports = [
    ./../../../modules/darwin/ollama
    ./../../../modules/darwin/wezterm
  ];
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.optimise.automatic = true;
  nix.extraOptions = ''
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
      "thunderbird"
    ];
    taps = [
      "homebrew/services"
    ];
  };

  plinton.services.ollama = {
    enable = true;
  };
  plinton.wezterm = {
    enable = true;
    use_homebrew = true;
  };

  # note: this is the nix-darwin option, which sets the PATH and such
  # but is not where confiugration happens
  programs.zsh.enable = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
