{
  description = "victor7w7r nixtrap config for common and specific hosts";
  # cd .. && rm -rf flakeable-test && cp -r flakeable flakeable-test && cd flakeable-test
  #jovian.nixosModules.default
  #chaotic.nixosModules.default
  #home-manager.nixosModules.home-manager
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    catppuccin-refind = {
      url = "github:catppuccin/refind";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    jovian.follows = "chaotic/jovian";
  };

  outputs = { nixpkgs, self, ... } @ inputs:
    let
      username = "victor7w7r";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        vm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ (import ./hosts/vm) ];
          specialArgs = { host="vm"; inherit self inputs username; };
        };
      };
    };

}
