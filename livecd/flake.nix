{
  nixConfig = {
    extra-substituters = [
      "https://nix-gaming.cachix.org"
      "https://nix-community.cachix.org"
      "https://attic.xuyh0120.win/lantian"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  inputs = {
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    home-manager = {
      url = "github:nix-community/home-manager";
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
        (import ./configuration.nix)
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
          modules = [
            (
              { ... }:
              {
                nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ];
              }
            )
            (import ./iso/minimal.nix)
          ]
          ++ commonModules;
          specialArgs = {
            inherit nix-cachyos-kernel;
            flavor = "minimal";
          };
        };
        # nix build .#nixosConfigurations.graphicallive.config.system.build.isoImage
        graphicallive = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (
              { ... }:
              {
                nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ];
              }
            )
            (import ./iso/graphical.nix)
          ]
          ++ commonModules;
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
