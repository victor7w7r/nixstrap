{
  den,
  inputs,
  main-mac,
  ...
}:
{
  flake-file.inputs.darwin = {
    url = "github:nix-darwin/nix-darwin";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [ (inputs.den.namespace "main-mac" false) ];

  den = {
    hosts.x86_64-darwin.main-mac = {
      hostName = "v7w7r-macmini81";
      users.victor7w7r = { };
    };

    default.darwin =
      {
        pkgs,
        user,
        ...
      }:
      {
        system.primaryUser = user;
        time.timeZone = "America/Guayaquil";

        #determinateNix = determinate.inputs.nix.packages."x86_64-darwin".default;

        environment.defaultPackages = with pkgs; [
          coreutils-full
          findutils
          gnugrep
          gnused
          hyperfine
          moreutils
          readline
          watch
          xxh
          x-cmd
          fd
          fpp
          fsql
          rm-improved
          mprocs
          m-cli
          cocoapods
          colima
          lima
          tailscale
        ];

        documentation = {
          enable = false;
          doc.enable = false;
          info.enable = false;
          man.enable = false;
        };

      };

    # sudo -H nix --extra-experimental-features "nix-command flakes" run nix-darwin/master#darwin-rebuild -- switch --flake .#macmini
    aspects.main-mac = {
      includes = with den.aspects; [
        main-mac.brew
        main-mac.launchctl
        main-mac.postexec
        main-mac.prefs
        main-mac.system

        cli._
        dev._
        misc.comm
        misc.fetch
        zen._
        kitty
      ];
    };
  };
}
