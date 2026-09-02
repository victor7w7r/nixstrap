{ containers, inputs, ... }: {

  flake-file.inputs.copyparty.url = "github:9001/copyparty";

  den.aspects.server.containers.nixos = {
    networking.firewall.allowedTCPPorts = [ 3922 3923 3945 ];

    containers.copyparty = containers.lib.call {
      ip = "10";
      name = "copyparty";
      imports = [ inputs.copyparty.nixosModules.default ];
      containers = null;

      forwardPorts = [
        {
          #http
          containerPort = 3923;
          hostPort = 3923;
          protocol = "tcp";
        }
        {
          #sftp
          containerPort = 3922;
          hostPort = 3922;
          protocol = "tcp";
        }
        {
          #smb
          containerPort = 3945;
          hostPort = 3945;
          protocol = "tcp";
        }
      ];

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
        tunnel.file = ../secrets/tunnel.age;
          file = ../secrets/copyparty-pass.age;
          owner = "copyparty";
          group = "copyparty";
        };
      };

      extra = pkgs: {
        nixpkgs.overlays = [ inputs.copyparty.overlays.default ];
        environment.systemPackages = [ pkgs.copyparty ];
      };

      systemd = pkgs: {
        funnel = containers.lib.funnel {
          inherit pkgs;
          incoming = "3923";
        };
      };

      services = config: __: {
        copyparty = {
          enable = true;
          settings = {
            i = "0.0.0.0";
            no-robots = true;
            theme = 2;
            xff-hdr = "x-forwarded-for";
            xff-src = "192.168.100.10,100.64.0.1,100.64.0.10";
          };
          accounts.victor7w7r.passwordFile = config.age.secrets.copyparty-pass.path;
        };
      };
    };
  };
}
