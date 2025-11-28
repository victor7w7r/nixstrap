{
  description = "victor7w7r nixtrap config for common and specific hosts";
  # sshfs victor7w7r@192.168.122.1:/home/victor7w7r/repositories/nixstrap /home/nixos/flakeable && cd flakeable-test
  # cd .. && rm -rf flakeable-test && cp -r flakeable flakeable-test && cd flakeable-test
  # sudo nixos-install --root /mnt --flake .#desktop
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
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ (import ./hosts/desktop) ];
          specialArgs = { host="desktop"; inherit self inputs username ; };
        };
      };
    };

}
