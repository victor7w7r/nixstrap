{ den, inputs, ... }:
{
  flake-file.inputs.nixos-wsl = {
    url = "github:nix-community/nixos-wsl";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-compat.follows = "";
  };

  perSystem.packages.wsl-toplevel = inputs.self.nixosConfigurations.wsl.config.system.build.toplevel;

  den = {
    hosts.x86_64-linux.wsl = {
      wsl.enable = true;
      users = {
        #root = { };
        victor7w7r = { };
      };
    };

    aspects.wsl = {
      includes = with den.aspects; [
        cli._
        dev.mise
        dev.tools
        dev.ccache
        gui._
        misc.comm
        misc.fetch
        pentest._

        cockpit
        emulation
        games
        root
        secrets
        victor7w7r
      ];

      nixos = {
        networking.hostName = "v7w7r-wsl";
      };
    };
  };
}
