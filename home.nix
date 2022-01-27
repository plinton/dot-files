{ config, pkgs, nixpkgs, ... }:

{
  # Let Home Manager install and manage itself.
  #programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  imports = [ ./terminal.nix ./kitty.nix ./neovim.nix ];
  nixpkgs.config.allowUnfree = true;
  home.username = "paul";
  home.homeDirectory = "/home/paul";
  home.packages = with pkgs; [
    tdesktop
    zoom-us
    kmix
  ];
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
          sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
        };
      }
    ];
    shellInit =
      ''
      if test -f /opt/dev/dev.fish
        source /opt/dev/dev.fish
      end
    '';
    shellAbbrs = {
      gsm = "git switch master";
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
