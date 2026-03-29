{
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    stable.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    };

    flakehub = {
      url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      nix-darwin,
      nix-homebrew,
      home-manager,
      determinate,
      self,
      ...
    }@inputs:
    {
      # sudo -H nix --extra-experimental-features "nix-command flakes" run nix-darwin/master#darwin-rebuild -- switch --flake .#macmini
      darwinConfigurations = {
        macmini = nix-darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [
            nix-homebrew.darwinModules.nix-homebrew
            determinate.darwinModules.default
            home-manager.darwinModules.home-manager
            (import ./configuration.nix)
            (import ./core)
            (import ./home)
          ];
          specialArgs = {
            host = "v7w7r-macmini81";
            user = "victor7w7r";
            inherit inputs;
            determinateNix = determinate.inputs.nix.packages."x86_64-darwin".default;
          };
        };
      };
    };
}
