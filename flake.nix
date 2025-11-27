{
  description = "victor7w7r nixtrap config for common and specific hosts";
  #sshfs victor7w7r@192.168.122.1:/home/victor7w7r/repositories/nixstrap /home/nixos/flakeable
  # cd .. && rm -rf flakeable-test && cp -r flakeable flakeable-test && cd flakeable-test
  # sudo nixos-install --root /mnt --flake .#desktop
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    refind-theme-catppuccin = {
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
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      home-manager,
      nixpkgs,
      nur,
      chaotic,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      lib = nixpkgs.lib;

      mkSystem =
        pkgs: system: hostname:
        pkgs.lib.nixosSystem {
          system = system;
          modules = [
            { networking.hostName = hostname; }
            ./system/apps.nix
            ./system/bootloader.nix
            ./system/kernel.nix
            ./system/mount-root.nix
            ./system/config.nix
            ./system/kernel.nix
            ./hosts/${hostname}/hardware-configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                extraSpecialArgs = { inherit inputs; };
                #users.notus = (./. + "/hosts/${hostname}/user.nix");
              };
              nixpkgs.overlays = [
                # Add nur overlay for Firefox addons
                #nur.overlay
                #(import ./overlays)
              ];
            }
          ];
          specialArgs = {
            inherit inputs;
            refind-theme-catppuccin = inputs.refind-theme-catppuccin;
          };
        };

    in
    {
      nixosConfigurations = {
        #laptop = mkSystem inputs.nixpkgs "x86_64-linux" "laptop";
        desktop = mkSystem inputs.nixpkgs "x86_64-linux" "desktop";
      };
    };

}
