{
  inputs = {
    mobile-nixos = {
      url = "github:mobile-nixos/mobile-nixos";
      flake = false;
    };
    impermanence.url = "github:nix-community/impermanence";

  };

  outputs =
    {
      self,
      nixpkgs,
      mobile-nixos,
      ...
    }:
    let
      username = "victor7w7r";
      system = "aarch64-linux";
    in
    {
      nixosConfigurations = {
        fajita = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (import "${mobile-nixos}/lib/configuration.nix" { device = "oneplus-fajita"; })
            ./configuration.nix
          ];
          specialArgs = {
            host = "v7w7r-fajita";
            inherit
              self
              username
              system
              ;
          };
        };
      };
    };
}
