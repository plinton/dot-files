{ ... }:

{
  users.users.paul.home = /Users/paul;

  imports = [
    ./../../../modules/darwin/ollama
  ];
  # Auto upgrade nix package and the daemon service.
  nix.optimise.automatic = true;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  ids.gids.nixbld = 30000;

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
  };

  plinton.services.ollama = {
    enable = true;
  };

  # note: this is the nix-darwin option, which sets the PATH and such
  # but is not where confiugration happens
  programs.zsh.enable = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
