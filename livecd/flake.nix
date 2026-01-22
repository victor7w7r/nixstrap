{
  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = [ "https://cache.garnix.io" ];
    extra-trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
    trusted-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.or"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcM="
    ];
  };

  inputs = {
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      home-manager,
      nix-cachyos-kernel,
      nixpkgs,
      self,
    }:
    let
      system = "x86_64-linux";
      commonModules = [
        home-manager.nixosModules.home-manager
        ./core
        ./home
      ];
    in
    {
      nixosConfigurations = {
        # nix build .#nixosConfigurations.minimallive.config.system.build.isoImage
        minimallive = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./iso/minimal.nix ] ++ commonModules;
          specialArgs = {
            inherit nix-cachyos-kernel;
            flavor = "minimal";
          };
        };
        # nix build .#nixosConfigurations.graphicallive.config.system.build.isoImage
        graphicallive = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./iso/graphical.nix ] ++ commonModules;
          specialArgs = {
            inherit nix-cachyos-kernel;
            flavor = "graphical";
          };
        };
      };
      packages."x86_64-linux" =
        (builtins.mapAttrs (n: v: v.config.system.build.isoImage) self.nixosConfigurations)
        // {
          default = self.packages."x86_64-linux"."minimallive";
        };
    };
}
