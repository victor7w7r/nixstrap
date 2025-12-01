{
  description = "victor7w7r nixtrap config for common and specific hosts";
  # sudo sshfs victor7w7r@192.168.122.1:repositories/nixstrap nixstrap

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    catppuccin-refind = {
      url = "github:catppuccin/refind";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      chaotic,
      self,
      ...
    }@inputs:
    let
      username = "victor7w7r";
    in
    {
      nixosConfigurations = {
        vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/vm
            chaotic.nixosModules.default
          ];
          specialArgs = {
            host = "vm";
            inherit self inputs username;
          };
        };
      };
    };
}
