{
  description = "victor7w7r nixtrap config for common and specific hosts";

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
    hardware.url = "https://flakehub.com/f/NixOS/nixos-hardware/0.1";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-flatpak.url = "https://flakehub.com/f/gmodena/nix-flatpak/0.7.0";
    compose2nix = {
      url = "https://flakehub.com/f/aksiksi/compose2nix/0.3.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/*";
    nix-alien.url = "https://flakehub.com/f/thiagokokada/nix-alien/0.1";
    nix-search-tv.url = "github:3timeslazy/nix-search-tv";
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
    batfetch = {
      url = "github:ashish-kus/batfetch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    swiftfetch = {
      url = "github:ly-sec/swiftfetch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    hyprland.url = "https://flakehub.com/f/hyprwm/Hyprland/0.53";
    pyprland.url = "github:hyprland-community/pyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    sops-nix = {
      url = "https://flakehub.com/f/Mic92/sops-nix/0.1";
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
      self,
      nix-cachyos-kernel,
      nur,
      impermanence,
      nix-flatpak,
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
            (
              { ... }:
              {
                nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ];
              }
            )
            (import ./configuration.nix)
            (import ./pkgs)
            nixos-hardware.nixosModules.apple-t2
            nix-flatpak.nixosModules.nix-flatpak
            (import ./hosts/macmini.nix)
            (import ./modules/core)
            (import ./modules/home)
            nur.modules.nixos.default
            impermanence.nixosModules.impermanence
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
            (
              { ... }:
              {
                nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ];
              }
            )
            (import ./configuration.nix)
            (import ./pkgs)
            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-laptop
            nixos-hardware.nixosModules.common-cpu-intel
            nix-flatpak.nixosModules.nix-flatpak
            impermanence.nixosModules.impermanence
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
            (
              { ... }:
              {
                nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ];
              }
            )
            (import ./configuration.nix)
            (import ./pkgs)
            nixos-hardware.nixosModules.asus-ally-rc71l
            nix-flatpak.nixosModules.nix-flatpak
            (import ./hosts/rogally.nix)
            (import ./modules/core)
            (import ./modules/home)
            nur.modules.nixos.default
            impermanence.nixosModules.impermanence
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
            (
              { ... }:
              {
                nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ];
              }
            )
            (import ./configuration.nix)
            (import ./pkgs)
            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-cpu-intel
            nix-flatpak.nixosModules.nix-flatpak
            impermanence.nixosModules.impermanence
            (import ./hosts/server.nix)
            (import ./modules/core)
            (import ./modules/home)
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
            (
              { ... }:
              {
                nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ];
              }
            )
            (import ./configuration.nix)
            (import ./pkgs)
            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-cpu-intel
            impermanence.nixosModules.impermanence
            nix-flatpak.nixosModules.nix-flatpak
            (import ./hosts/vm.nix)
            (import ./modules/core)
            (import ./modules/home)
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
