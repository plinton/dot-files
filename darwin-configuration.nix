{ config, pkgs, ... }:
let
  pkgsUnstable = import <nixos-unstable> {};
in {
  imports = [ <home-manager/nix-darwin> ];
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.vim
      pkgs.home-manager
      pkgs.bash
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  home-manager.useUserPackages = true;
  home-manager.users.paulellislinton = { pkgs, ...}: {
    home.packages = with pkgsUnstable; [
      python3
      ripgrep
      ruby
      delta
      bat
      git
      fzf
      fd
      poetry
      procs
      yq-go
      jq
      google-cloud-sdk
      shellharden
      sd
      fastmod
      xsv
      #neovim
        #neovim.override {
        #  
        #}
      #)
    ];
    home.sessionVariables = {
      EDITOR = "nvim";
      FZF_DEFAULT_COMMAND = "rg --files --hidden";
    };
    programs.neovim = {
      enable = true;
      withRuby = false;
      extraConfig = builtins.readFile ~/.config/nvim/base.vim;
        extraPackages = with pkgsUnstable; [
          nodePackages.typescript-language-server
          pyright
        ];
        plugins = with pkgsUnstable.vimPlugins; [
            gitsigns-nvim
            plenary-nvim
            nvim-lspconfig
            vim-sensible
            vim-surround
            vim-fugitive
            vim-swap
            #delimitMate
            vim-matchup
            nvim-ts-rainbow
            nvim-autopairs
            vim-illuminate
            split-term-vim
            vim-sleuth
            nvim-compe
            fzf-vim fzfWrapper
            nvim-web-devicons
            lualine-nvim
            nvim-treesitter
            nvim-treesitter-context
            nvim-treesitter-refactor
            which-key-nvim
            lsp_signature-nvim
            nvim-cmp cmp-nvim-lsp cmp-nvim-lua cmp-buffer cmp-path # cmp-treesitter
            gitlinker-nvim
          ];
    };
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
      programs.zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
        initExtra = builtins.readFile ~/.config/zsh/zshrc;
      };
    };

    # Create /etc/bashrc that loads the nix-darwin environment.
    programs.zsh.enable = true;  # default shell on catalina
    #programs.fish.enable = true;

    users.users.paulellislinton = {
      shell = pkgs.fish;
    };

    fonts.enableFontDir = true;
    fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "DroidSansMono" ]; })
  ];

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 4;
  }
