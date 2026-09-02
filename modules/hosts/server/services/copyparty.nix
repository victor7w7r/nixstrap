{ inputs, ... }: {

  flake-file.inputs.copyparty.url = "github:9001/copyparty";

  den.aspects.server.services.copyparty.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.copyparty.nixosModules.default ];

      age.secrets.copyparty-pass = {
        file = ../secrets/copyparty-pass.age;
        owner = "copyparty";
        group = "copyparty";
      };

      networking.firewall = {
        allowedTCPPorts = [
          8080
          3923
        ];
        interfaces."tailscale0".allowedTCPPorts = [
          8080
          3923
        ];
      };
      nixpkgs.overlays = [ inputs.copyparty.overlays.default ];
      environment = {
        systemPackages = [ pkgs.copyparty ];
        persistence."/nix/persist".directories = lib.mkAfter [
          {
            directory = "/var/lib/copyparty";
            mode = "0755";
            user = "copyparty";
            group = "copyparty";
          }
          {
            directory = "/var/cache/copyparty";
            mode = "0755";
            user = "copyparty";
            group = "copyparty";
          }
        ];
      };
      services.copyparty = {
        enable = true;
        settings = {
          i = "0.0.0.0";
          no-robots = true;
          theme = 2;
          xff-hdr = "x-forwarded-for";
          xff-src = "192.168.100.10,100.64.0.1";
        };
        accounts.victor7w7r.passwordFile = config.age.secrets.copyparty-pass.path;
      };
    };
}
