{
  description = "victor7w7r nixtrap config for common and specific hosts";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      myHosts = {
        "macmini" = {
          system = "x86_64-linux";
          hostSpecificNix = ./nixos/hosts/macmini/configuration.nix;
          hostSpecificHomeConfig = ./home-manager/hosts/macmini.nix;
          enableGui = true;
          enableSystem = true;
          defaultUsername = "victor7w7r";
        };
        "system-test" = {
          system = "x86_64-linux";
          enableGui = true;
          enableSystem = true;
          defaultUsername = "test";
          hostSpecificNix = { };
        };
        "container" = {
          system = "x86_64-linux";
          enableGui = false;
          enableSystem = false;
          defaultUsername = "root";
        };
      };

      getUsernameForHost = hostname: hostAttrs:
        let
          envUser = "victor7w7r"; #builtins.getEnv "NIX_USERNAME";
          hostDefaultUser = hostAttrs.defaultUsername;
        in if envUser != "" then envUser else hostDefaultUser;

      mkNixosSystem = hostname: hostAttrs:
        let
          system = hostAttrs.system;
          username = getUsernameForHost hostname hostAttrs;
          specialArgs = {
            inherit inputs hostname username;
            enableGui = hostAttrs.enableGui;
            hostSpecificHomeConfig = hostAttrs.hostSpecificHomeConfig or null;
          };
        in nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ({ pkgs, lib, ... }: { })
            ./nixos/configuration.nix
            hostAttrs.hostSpecificNix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              #home-manager.users.${username} = import ./home.nix;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.backupFileExtension = "hm-backup";
            }
          ];
        };

      mkHomeManagerConfiguration = hostname: hostAttrs:
        let
          system = hostAttrs.system;
          username = getUsernameForHost hostname hostAttrs;
          pkgs = import nixpkgs { inherit system; };
          specialArgs = {
            inherit inputs username hostname;
            enableGui = hostAttrs.enableGui;
            hostSpecificHomeConfig = hostAttrs.hostSpecificHomeConfig or null;
          };
        in home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = specialArgs;
        };

      nixosHosts =
        nixpkgs.lib.filterAttrs (name: attrs: attrs.enableSystem) myHosts;
      homeManagerHosts =
        nixpkgs.lib.filterAttrs (name: attrs: !attrs.enableSystem) myHosts;

    in {
      nixosConfigurations = nixpkgs.lib.mapAttrs mkNixosSystem nixosHosts;

      homeConfigurations = nixpkgs.lib.mapAttrs' (hostname: hostAttrs:
        nixpkgs.lib.nameValuePair hostname
        (mkHomeManagerConfiguration hostname hostAttrs)) homeManagerHosts;
    };
}
