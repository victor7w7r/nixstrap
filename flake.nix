{
  description = "victor7w7r nixtrap config for common and specific hosts";
  # cd .. && rm -rf flakeable-test && cp -r flakeable flakeable-test && cd flakeable-test
  #jovian.nixosModules.default
  #chaotic.nixosModules.default
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
    hyprpicker.url = "github:hyprwm/hyprpicker";
    pyprland.url = "github:hyprland-community/pyprland";
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };
    jovian.follows = "chaotic/jovian";
  };

  outputs =
    { nixpkgs, self, ... }@inputs:
    let
      username = "victor7w7r";
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        vm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ (import ./hosts/vm) ];
          specialArgs = {
            host = "vm";
            inherit self inputs username;
          };
        };
      };
    };

}
