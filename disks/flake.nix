{
  nixConfig.experimental-features = [
    "nix-command"
    "flakes"
  ];
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { disko, nixpkgs, self }:
    {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          modules = [
            disko.nixosModules.disko
            ./hosts/laptop.nix
          ];
        };
        macmini = nixpkgs.lib.nixosSystem {
          modules = [
            disko.nixosModules.disko
            ./hosts/macmini.nix
          ];
        };
        rogally = nixpkgs.lib.nixosSystem {
          modules = [
            disko.nixosModules.disko
            ./hosts/rogally.nix
          ];
        };
        rogallyvm = nixpkgs.lib.nixosSystem {
          modules = [
            disko.nixosModules.disko
            ./hosts/rogallyvm.nix
          ];
        };
        server = nixpkgs.lib.nixosSystem {
          modules = [
            disko.nixosModules.disko
            ./hosts/server.nix
          ];
        };
        vm = nixpkgs.lib.nixosSystem {
          modules = [
            disko.nixosModules.disko
            ./hosts/vm.nix
          ];
        };
      };
      packages."x86_64-linux" =
        (builtins.mapAttrs (n: v: v.config.system.build.isoImage) self.nixosConfigurations)
        // {
          default = self.packages."x86_64-linux"."minimallive";
        };
    };
}
