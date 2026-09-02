{ containers, inputs, ... }: {

  flake-file.inputs.copyparty.url = "github:9001/copyparty";

  den.aspects.server.containers.nixos = {
    networking.firewall.allowedTCPPorts = [
      8080
      3923
    ];

    containers.copyparty = containers.lib.call {
      ip = "10";
      name = "copyparty";
      imports = [ inputs.copyparty.nixosModules.default ];

      forwardPorts = [
        {
          containerPort = 3923;
          hostPort = 3923;
          protocol = "tcp";
        }
        {
          containerPort = 8080;
          hostPort = 8080;
          protocol = "tcp";
        }
      ];
      #copyparty
      bindMounts = {
        "/var/lib/copyparty" = {
          hostPath = "/nix/persist/containers/copyparty/data";
          isReadOnly = false;
        };
        "/var/cache/copyparty" = {
          hostPath = "/nix/persist/containers/copyparty/cache";
          isReadOnly = false;
        };
      };

      secrets = {
        copyparty-pass = {
          file = ../secrets/copyparty-pass.age;
          owner = "copyparty";
          group = "copyparty";
        };
      };

      extra = pkgs: {
        nixpkgs.overlays = [ inputs.copyparty.overlays.default ];
        environment.systemPackages = [ pkgs.copyparty ];
      };

      services = config: __: {
        copyparty = {
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
    };
  };
}
