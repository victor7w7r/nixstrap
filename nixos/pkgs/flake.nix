{
  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://chaotic-nyx.cachix.org"
    ];
    trusted-public-keys = [
      "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
    ];
  };

  inputs = {
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      home-manager,
      chaotic,
      nixpkgs,
      self,
    }:
    {
      nixosConfigurations = {
        # nix build .#nixosConfigurations.minimallive.config.system.build.isoImage
        minimallive = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./iso/minimal.nix
            home-manager.nixosModules.home-manager
            chaotic.nixosModules.default
            ./core
            ./home
          ];
          specialArgs.flavor = "minimal";
        };
        # nix build .#nixosConfigurations.graphicallive.config.system.build.isoImage
        graphicallive = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./iso/graphical.nix
            home-manager.nixosModules.home-manager
            chaotic.nixosModules.default
            ./core
            ./home
          ];
          specialArgs.flavor = "graphical";
        };
      };
      packages."x86_64-linux" =
        (builtins.mapAttrs (n: v: v.config.system.build.isoImage) self.nixosConfigurations)
        // {
          default = self.packages."x86_64-linux"."minimallive";
        };
    };
}
