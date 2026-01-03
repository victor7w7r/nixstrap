{
  description = "victor7w7r nixtrap config for common and specific hosts";
  # mkdir -p nixstrap nixtemp && sudo sshfs victor7w7r@192.168.122.1:repositories/nixstrap nixstrap
  # cd nixtemp && cd .. && rm -rf nixtemp && cp -r nixstrap nixtemp && cd nixtemp

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://install.determinate.systems"
    ];
    extra-substituters = [
      "https://chaotic-nyx.cachix.org"
      "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  inputs = {
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    hardware.url = "github:nixos/nixos-hardware";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nixos-conf-editor.url = "github:snowfallorg/nixos-conf-editor";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/*";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    pyprland.url = "github:hyprland-community/pyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin-refind = {
      url = "github:catppuccin/refind";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      chaotic,
      self,
      nur,
      sops-nix,
      nixos-hardware,
      ...
    }@inputs:
    let
      username = "victor7w7r";
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        macmini = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (import ./configuration.nix)
            (import ./pkgs)
            nixos-hardware.nixosModules.apple-t2
            (import ./hosts/macmini.nix)
            (import ./modules/core)
            (import ./modules/home)
            chaotic.nixosModules.default
            nur.modules.nixos.default
            sops-nix.nixosModules.sops
          ];
          specialArgs = {
            host = "v7w7r-macmini81";
            inherit
              self
              sops-nix
              inputs
              username
              system
              ;
          };
        };

        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (import ./configuration.nix)
            (import ./pkgs)
            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-laptop
            nixos-hardware.nixosModules.common-cpu-intel
            chaotic.nixosModules.default
            nur.modules.nixos.default
            sops-nix.nixosModules.sops
            (import ./hosts/laptop.nix)
            (import ./modules/core)
            (import ./modules/home)
          ];
          specialArgs = {
            host = "v7w7r-dynabook";
            inherit
              self
              sops-nix
              inputs
              username
              system
              ;
          };
        };

        rogally = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (import ./configuration.nix)
            (import ./pkgs)
            nixos-hardware.nixosModules.asus-ally-rc71l
            (import ./hosts/rogally.nix)
            (import ./modules/core)
            (import ./modules/home)
            chaotic.nixosModules.default
            nur.modules.nixos.default
            sops-nix.nixosModules.sops
            nur.legacyPackages."${system}".repos.Vortriz.libfprint-focaltech-2808-a658-alt
          ];
          specialArgs = {
            host = "v7w7r-rc71l";
            inherit
              self
              sops-nix
              inputs
              username
              system
              ;
          };
        };

        rogallyvm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (import ./configuration.nix)
            (import ./pkgs)
            nixos-hardware.nixosModules.asus-ally-rc71l
            (import ./hosts/rogallyvm.nix)
            (import ./modules/core)
            (import ./modules/home)
            chaotic.nixosModules.default
            nur.modules.nixos.default
            sops-nix.nixosModules.sops
          ];
          specialArgs = {
            host = "v7w7r-rc71l";
            inherit
              self
              sops-nix
              inputs
              username
              system
              ;
          };
        };

        server = nixpkgs-stable.lib.nixosSystem {
          inherit system;
          modules = [
            (import ./configuration.nix)
            (import ./pkgs)
            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-cpu-intel
            (import ./hosts/server.nix)
            (import ./modules/core)
            (import ./modules/home)
            chaotic.nixosModules.default
            nur.modules.nixos.default
            sops-nix.nixosModules.sops
          ];
          specialArgs = {
            host = "v7w7r-youyeetoox1";
            inherit
              self
              sops-nix
              inputs
              username
              system
              ;
          };
        };

        vm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (import ./configuration.nix)
            (import ./pkgs)
            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-cpu-intel
            (import ./hosts/vm.nix)
            (import ./modules/core)
            (import ./modules/home)
            chaotic.nixosModules.default
            nur.modules.nixos.default
            sops-nix.nixosModules.sops
          ];
          specialArgs = {
            host = "v7w7r-nixvm";
            inherit
              self
              sops-nix
              inputs
              username
              system
              ;
          };
        };
      };
    };
}
