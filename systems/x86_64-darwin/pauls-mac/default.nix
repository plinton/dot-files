{...}: {
  users.users.paul.home = /Users/paul;

  imports = [
    ./../../../modules/darwin/ollama
  ];
  nix.optimise.automatic = true;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.settings = {
    # sandbox has issues on macos, trust the defaults instead
    #sandbox = true;
    #extra-sandbox-paths = ["/nix/store"];
    extra-substituters = ["https://devenv.cachix.org" "https://nixpkgs-ruby.cachix.org"];
    extra-trusted-public-keys = ["devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" "nixpkgs-ruby.cachix.org-1:vrcdi50fTolOxWCZZkw0jakOnUI1T19oYJ+PRYdK4SM="];
  };
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
  security.pam.services.sudo_local.touchIdAuth = true;
  

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
