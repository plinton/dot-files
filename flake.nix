# Originally based on https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050
{
  description = "Paul's systems";

  inputs = {
    # Package sets
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Other sources
  };

  outputs = {
    self,
    darwin,
    nixpkgs,
    home-manager,
    lix-module,
    nixvim,
    catppuccin,
    ...
  } @ inputs: let
    inherit (darwin.lib) darwinSystem;
    inherit (inputs.nixpkgs-unstable.lib) optionalAttrs singleton;

    # Configuration for `nixpkgs`
    nixpkgsConfig = {
      config = {
        allowUnfree = true;
      };
      overlays = singleton (
        final: prev: (optionalAttrs (prev.stdenv.system == "x86_64-darwin") {
          # some tests fail sometimes, at least on x86_64-darwin
          aws-sdk-cpp = prev.aws-sdk-cpp.overrideAttrs (oldAttrs: {
            cmakeFlags = oldAttrs.cmakeFlags ++ ["-DENABLE_TESTING=OFF"];
          });
        })
      );
    };
  in {
    # set formatter
    formatter = {
      x86_64-linux = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.alejandra;
      x86_64-darwin = inputs.nixpkgs-unstable.legacyPackages.x86_64-darwin.alejandra;
    };

    nixosConfigurations.mr-laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      #specialArgs = attrs;
      modules = [
        # main configuration
        ./systems/x86_64-linux/mr-laptop

        home-manager.nixosModules.home-manager
        {
          nixpkgs = nixpkgsConfig;
          # `home-manager` config
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.paul = import (./homes/x86_64-linux + "/paul@mr-laptop");
        }
      ];
    };
    # My `nix-darwin` configs
    darwinConfigurations = {
      pauls-mac = darwinSystem {
        system = "x86_64-darwin";
        modules = [
          # Main `nix-darwin` config
          ./systems/x86_64-darwin/pauls-mac
          # lix-module
          lix-module.nixosModules.default

          # `home-manager` module
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            # `home-manager` config
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.paul = import (./homes/x86_64-darwin + "/paul@pauls-mac");
            home-manager.extraSpecialArgs = {inherit nixvim catppuccin;};
          }
        ];
      };
    };
  };
}
