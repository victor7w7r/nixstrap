{ containers, inputs, ... }: {

  flake-file.inputs.copyparty.url = "github:9001/copyparty";

  den.aspects.server.containers.nixos = {
    networking.firewall.allowedTCPPorts = [
      3922
      3923
    ];

    containers.copyparty = containers.lib.call {
      ip = "10";
      name = "copyparty";
      imports = [ inputs.copyparty.nixosModules.default ];
      containers = null;

      forwardPorts = [
        {
          containerPort = 3923;
          hostPort = 3923;
          protocol = "tcp";
        }
        {
          containerPort = 3922;
          hostPort = 3922;
          protocol = "tcp";
        }
      ];

      bindMounts = {
        "/cloud" = {
          hostPath = "/nix/persist/cloud";
          isReadOnly = false;
        };
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
        tunnel.file = ../secrets/tunnel.age;
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

      systemd = pkgs: {
        funnel = containers.lib.funnel {
          inherit pkgs;
          incoming = "3923";
        };
      };

      services = config: pkgs: {
        copyparty = {
          enable = true;
          package = pkgs.copyparty.overridePythonAttrs (old: {
            propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
              pkgs.python3Packages.paramiko
            ];
          });
          settings = {
            i = "0.0.0.0";
            p = "3922,3923";
            theme = 2;
            lang = "esp";
            sftp = "3922";
            #xff-hdr = "x-forwarded-for";
            #xff-src = "192.168.100.10,100.64.0.1,100.64.0.10";
          };
          accounts.victor7w7r.passwordFile = config.age.secrets.copyparty-pass.path;
          volumes = {
            "/" = {
              path = "/cloud";
              access = {
                A = [ "victor7w7r" ];
              };
              flags = {
                fk = 4;
                scan = 60;
                e2d = true;
                d2t = true;
                grid = true;
                dothidden = true;
                nohash = "\.iso$";
              };
            };
          };
        };
      };
    };
  };
}
