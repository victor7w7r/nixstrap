{
  nixConfig = {
    extra-substituters = [
      "https://attic.xuyh0120.win/lantian"
    ];
    extra-trusted-public-keys = [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
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
