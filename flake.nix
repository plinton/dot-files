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
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0-rc1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Other sources

  };

  outputs = { self, darwin, nixpkgs, home-manager, lix-module, ... }@inputs:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;

      # Configuration for `nixpkgs`
      nixpkgsConfig = {
        config = { allowUnfree = true; };
      };
    in
    {
      # set formatter
      formatter = {
        x86_64-linux = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.nixpkgs-fmt;
        x86_64-darwin = inputs.nixpkgs-unstable.legacyPackages.x86_64-darwin.nixpkgs-fmt;
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
      darwinConfigurations = rec {
        pauls-mac = darwinSystem {
          system = "x86_64-darwin";
          modules = attrValues self.darwinModules ++ [
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
            }
          ];
        };
      };

      # Overlays --------------------------------------------------------------- {{{

      overlays = {
        # Overlays to add various packages into package set

        # Overlay useful on Macs with Apple Silicon
        apple-silicon = final: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          # Add access to x86 packages system is running Apple Silicon
          pkgs-x86 = import inputs.nixpkgs-unstable {
            system = "x86_64-darwin";
            inherit (nixpkgsConfig) config;
          };

        };
      };

      # My `nix-darwin` modules that are pending upstream, or patched versions waiting on upstream
      # fixes.
      darwinModules = { };
    };
}
