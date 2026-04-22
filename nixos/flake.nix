{
  description = "victor7w7r nixtrap config for common and specific hosts";

  nixConfig = {
    extra-sandbox-paths = [
      "/nix/var/cache/ccache"
      "/nix/var/cache/sccache"
    ];
    extra-substituters = [
      "https://nix-gaming.cachix.org"
      "https://nix-community.cachix.org"
      "https://attic.xuyh0120.win/lantian"
      "https://cache.garnix.io"
      "https://cache.saumon.network/proxmox-nixos"
    ];
    extra-trusted-public-keys = [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "proxmox-nixos:D9RYSWpQQC/msZUWphOY2I5RLH5Dd6yQcaHIuug7dWM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  inputs = {
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    hardware.url = "https://flakehub.com/f/NixOS/nixos-hardware/0.1";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mobile-nixos = {
      url = "github:mobile-nixos/mobile-nixos";
      flake = false;
    };
    nix-flatpak.url = "https://flakehub.com/f/gmodena/nix-flatpak/0.7.0";
    compose2nix = {
      url = "https://flakehub.com/f/aksiksi/compose2nix/0.3.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    gestures.url = "github:ferstar/gestures";
    nix-gaming.url = "github:fufexan/nix-gaming";
    thorium.url = "github:almahdi/nix-thorium";
    opi-zero2w.url = "github:virusdave/nixos-opi-zero2w";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    nix-alien.url = "https://flakehub.com/f/thiagokokada/nix-alien/0.1";
    nix-search-tv.url = "github:3timeslazy/nix-search-tv";
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
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin-refind = {
      url = "github:catppuccin/refind";
      flake = false;
    };
    kwin-effects-better-blur-dx = {
      url = "github:xarblu/kwin-effects-better-blur-dx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      self,
      nix-cachyos-kernel,
      nur,
      disko,
      proxmox-nixos,
      impermanence,
      home-manager,
      nix-flatpak,
      nixvim,
      sops-nix,
      nixos-hardware,
      ...
    }@inputs:
    let
      username = "victor7w7r";
      system = "x86_64-linux";
      systemarm = "aarch64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          nix-cachyos-kernel.overlays.pinned
        ];
      };
      armPkgs = import nixpkgs {
        system = systemarm;
        overlays = [
          (import "${inputs.mobile-nixos}/overlay/overlay.nix")
        ];
      };

      home = (pkgs.callPackage ./modules/home { inherit self inputs username; }).home-manager;
      helpers = pkgs.callPackage "${inputs.nix-cachyos-kernel.outPath}/helpers.nix" { };
    in
    {
      packages = {
        "${systemarm}" = {
          sunxiconfig =
            (armPkgs.callPackage ./kernel/sunxi {
              kernelData = nixpkgs.lib.trivial.importJSON ./kernel.json;
            }).kernel.kconfigToNix;

          qcomkernel =
            (armPkgs.callPackage ./kernel/sdm845 {
              inherit inputs;
              kernelData = nixpkgs.lib.trivial.importJSON ./kernel.json;
            }).build;

          qcomconfig =
            (armPkgs.callPackage ./kernel/sdm845 {
              inherit inputs;
              kernelData = nixpkgs.lib.trivial.importJSON ./kernel.json;
            }).build.kconfigToNix;
        };
        "${system}" = {
          rogallyconfig =
            (pkgs.callPackage ./kernel {
              host = "v7w7r-rc71l";
              inherit helpers inputs;
              kernelData = nixpkgs.lib.trivial.importJSON ./kernel.json;
            }).kernel.kconfigToNix;

          higoleconfig =
            (pkgs.callPackage ./kernel {
              host = "v7w7r-higole";
              inherit helpers inputs;
              kernelData = nixpkgs.lib.trivial.importJSON ./kernel.json;
            }).kernel.kconfigToNix;

          serverconfig =
            (pkgs.callPackage ./kernel {
              host = "v7w7r-youyeetoox1";
              inherit helpers inputs;
              kernelData = nixpkgs.lib.trivial.importJSON ./kernel.json;
            }).kernel.kconfigToNix;

          macminiconfig =
            (pkgs.callPackage ./kernel {
              host = "v7w7r-macmini81";
              inherit helpers inputs;
              kernelData = nixpkgs.lib.trivial.importJSON ./kernel.json;
            }).kernel.kconfigToNix;
        };
      };

      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        inherit (home)
          extraSpecialArgs
          ;
      };

      nixosConfigurations = {
        #nix build -L ".#nixosConfigurations.opizero2w.config.system.build.sdImage"
        #nix build -L ".#nixosConfigurations.opizero2w.config.system.build.toplevel"
        opizero2w = nixpkgs.lib.nixosSystem {
          system = systemarm;
          modules = [
            (
              { ... }:
              {
                nixpkgs.hostPlatform = "aarch64-linux";
                nixpkgs.config.allowUnsupportedSystem = true;
                nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];
              }
            )
            (import ./configuration.nix)
            (import ./pkgs)
            (import ./hosts/opizero2w.nix)
            impermanence.nixosModules.impermanence
            home-manager.nixosModules.home-manager
            disko.nixosModules.disko
            nur.modules.nixos.default
            nixvim.nixosModules.nixvim
            sops-nix.nixosModules.sops
            (import ./modules/core)
            (import ./modules/home)
          ];
          specialArgs = {
            host = "v7w7r-opizero2w";
            system = systemarm;
            kernelData = nixpkgs.lib.trivial.importJSON ./kernel.json;
            inherit
              self
              sops-nix
              inputs
              username
              ;
          };
        };

        #nix build -L ".#nixosConfigurations.fajita.config.mobile.outputs.android.android-bootimg"
        #nix build -L ".#nixosConfigurations.fajita.config.mobile.outputs.generatedFilesystems.rootfs"
        #nix build -L ".#nixosConfigurations.fajita.config.mobile.outputs.android.android-fastboot-images"
        fajita = nixpkgs.lib.nixosSystem {
          system = systemarm;
          modules = [
            (
              { ... }:
              {
                nixpkgs.hostPlatform = "aarch64-linux";
                nixpkgs.config.allowUnsupportedSystem = true;
                nixpkgs.overlays = [
                  inputs.emacs-overlay.overlay
                  (final: prev: {
                    cached-nix-shell = prev.cached-nix-shell.overrideAttrs (old: {
                      CARGO_FEATURE_NO_ASM = "1";
                    });
                  })
                ];
              }
            )
            (import ./configuration.nix)
            (import ./pkgs)
            (import ./hosts/fajita.nix)
            impermanence.nixosModules.impermanence
            home-manager.nixosModules.home-manager
            nur.modules.nixos.default
            nixvim.nixosModules.nixvim
            sops-nix.nixosModules.sops
            (import ./modules/core)
            (import ./modules/home)
          ]
          ++ (import "${inputs.mobile-nixos}/modules/module-list.nix");
          specialArgs = {
            host = "v7w7r-fajita";
            system = systemarm;
            kernelData = nixpkgs.lib.trivial.importJSON ./kernel.json;
            inherit
              self
              sops-nix
              inputs
              username
              ;
          };
        };

        macmini = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (
              { ... }:
              {
                nixpkgs.overlays = [
                  nix-cachyos-kernel.overlays.pinned
                  inputs.emacs-overlay.overlay
                ];
              }
            )
            (import ./configuration.nix)
            (import ./pkgs)
            nixos-hardware.nixosModules.apple-t2
            nur.modules.nixos.default
            nix-flatpak.nixosModules.nix-flatpak
            impermanence.nixosModules.impermanence
            home-manager.nixosModules.home-manager
            nixvim.nixosModules.nixvim
            (import ./hosts/macmini.nix)
            (import ./modules/core)
            (import ./modules/home)
            sops-nix.nixosModules.sops
          ];
          specialArgs = {
            host = "v7w7r-macmini81";
            kernelData = nixpkgs.lib.trivial.importJSON ./kernel.json;
            inherit
              self
              sops-nix
              inputs
              username
              system
              ;
          };
        };

        higole = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (
              { ... }:
              {
                nixpkgs.overlays = [
                  nix-cachyos-kernel.overlays.pinned
                  inputs.emacs-overlay.overlay
                ];
              }
            )
            (import ./configuration.nix)
            (import ./pkgs)
            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-pc-laptop
            nixos-hardware.nixosModules.common-cpu-intel
            nix-flatpak.nixosModules.nix-flatpak
            impermanence.nixosModules.impermanence
            home-manager.nixosModules.home-manager
            nur.modules.nixos.default
            nixvim.nixosModules.nixvim
            sops-nix.nixosModules.sops
            (import ./hosts/higole.nix)
            (import ./modules/core)
            (import ./modules/home)
          ];
          specialArgs = {
            host = "v7w7r-higole";
            kernelData = nixpkgs.lib.trivial.importJSON ./kernel.json;
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
                nixpkgs.overlays = [
                  nix-cachyos-kernel.overlays.pinned
                  inputs.emacs-overlay.overlay
                ];
              }
            )
            (import ./configuration.nix)
            (import ./pkgs)
            nixos-hardware.nixosModules.asus-ally-rc71l
            nix-flatpak.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
            nixvim.nixosModules.nixvim
            (import ./hosts/rogally.nix)
            (import ./modules/core)
            (import ./modules/home)
            nur.modules.nixos.default
            impermanence.nixosModules.impermanence
            sops-nix.nixosModules.sops
          ];
          specialArgs = {
            host = "v7w7r-rc71l";
            kernelData = nixpkgs.lib.trivial.importJSON ./kernel.json;
            inherit
              self
              sops-nix
              nix-cachyos-kernel
              inputs
              username
              system
              ;
          };
        };

        server = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (
              { ... }:
              {
                nixpkgs.overlays = [
                  nix-cachyos-kernel.overlays.default
                  inputs.emacs-overlay.overlay
                  proxmox-nixos.overlays.${system}
                ];
              }
            )
            (import ./configuration.nix)
            (import ./pkgs)
            nixos-hardware.nixosModules.common-pc-ssd
            proxmox-nixos.nixosModules.proxmox-ve
            nixos-hardware.nixosModules.common-cpu-intel
            home-manager.nixosModules.home-manager
            nix-flatpak.nixosModules.nix-flatpak
            impermanence.nixosModules.impermanence
            nixvim.nixosModules.nixvim
            (import ./hosts/server.nix)
            (import ./modules/core)
            (import ./modules/home)
            nur.modules.nixos.default
            sops-nix.nixosModules.sops
          ];
          specialArgs = {
            host = "v7w7r-youyeetoox1";
            kernelData = nixpkgs.lib.trivial.importJSON ./kernel.json;
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
                nixpkgs.overlays = [
                  nix-cachyos-kernel.overlays.pinned
                  inputs.emacs-overlay.overlay
                ];
              }
            )
            (import ./configuration.nix)
            (import ./pkgs)
            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-cpu-intel
            impermanence.nixosModules.impermanence
            home-manager.nixosModules.home-manager
            nixvim.nixosModules.nixvim
            nix-flatpak.nixosModules.nix-flatpak
            (import ./hosts/vm.nix)
            (import ./modules/core)
            (import ./modules/home)
            nur.modules.nixos.default
            sops-nix.nixosModules.sops
          ];
          specialArgs = {
            host = "v7w7r-nixvm";
            kernelData = nixpkgs.lib.trivial.importJSON ./kernel.json;
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
