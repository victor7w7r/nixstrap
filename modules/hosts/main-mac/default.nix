{
  den,
  flakelib,
  inputs,
  ...
}:
{
  flake-file.inputs.darwin = {
    url = "github:nix-darwin/nix-darwin";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # sudo -H nix --extra-experimental-features "nix-command flakes" run nix-darwin/master#darwin-rebuild -- switch --flake .#macmini
  den = {
    #hosts.x86_64-darwin.main-mac.users.victor7w7r = { };

    aspects.main-mac = {
      includes = with den.aspects; [
        main-mac._

        cli._
        dev._
        misc.comm
        misc.fetch
        zen._
        kitty
      ];
    };

    default.darwin =
      { lib, ... }:
      {
        #determinateNix = determinate.inputs.nix.packages."x86_64-darwin".default;
        imports = [ inputs.determinate.darwinModules.default ];
        system = {
          checks.verifyBuildUsers = false;
          stateVersion = 6;
        };

        nix = {
          enable = lib.mkForce false;
          nixPath = lib.mkDefault [ ];
          optimise.automatic = lib.mkDefault false;
        };

        determinateNix.customSettings = {
          flake-registry = "/etc/nix/flake-registry.json";
          sandbox = "relaxed";
        }
        // (flakelib.config.flake-config { })
        // (flakelib.config.nix-config { });

        documentation = {
          enable = false;
          doc.enable = false;
          info.enable = false;
          man.enable = false;
        };
      };
  };
}
