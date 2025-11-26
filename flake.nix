{
  description = "victor7w7r nixtrap config for common and specific hosts";
  #sshfs victor7w7r@192.168.122.1:/home/victor7w7r/repositories/nixstrap /home/nixos/flakeable
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    refind-theme-catppuccin.url = "github:catppuccin/refind";
    refind-theme-catppuccin.flake = false;
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
            ./modules/system/sysapps.nix
            ./modules/system/bootloader.nix
            ./modules/system/mount-root.nix
            ./modules/system/configuration.nix
            ./modules/system/security.nix
            ./modules/system/locale.nix
            ./modules/system/fonts.nix
            #(./. + "/hosts/${hostname}/hardware-configuration.nix")
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
          specialArgs = { inherit inputs; };
        };

    in
    {
      nixosConfigurations = {
        #laptop = mkSystem inputs.nixpkgs "x86_64-linux" "laptop";
        desktop = mkSystem inputs.nixpkgs "x86_64-linux" "desktop";
      };
    };

}
