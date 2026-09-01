{ inputs, ... }: {
  den.aspects.pizero.passbolt.nixos = { lib, pkgs, ... }: {
    imports = [ inputs.agenix.nixosModules.default ];

    age = {
      identityPaths = lib.mkForce [ "/etc/ssh/ssh_host_ed25519_key" ];
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    systemd = {
      tmpfiles.rules = [
        "d /nix/persist/passbolt/gpg 0770 root 33 -"
        "z /nix/persist/passbolt/gpg 0770 root 33 -"
        "d /nix/persist/passbolt/jwt 0770 root 33 -"
        "z /nix/persist/passbolt/jwt 0770 root 33 -"
        "d /nix/persist/passbolt/mariadb 0770 999 999 -"
        "z /nix/persist/passbolt/mariadb 0770 999 999 -"
      ];

      services = {
        tailscaled.environment.TS_LOG_LEVEL = "0";
        docker.after = [ "chronyd.service" ];
        tailscaled.after = [ "chronyd.service" ];
        funnel = {
          wantedBy = [ "multi-user.target" ];
          after = [ "docker-passbolt.service" ];
          wants = [ "docker-passbolt.service" ];
          serviceConfig = {
            RestartSec = "10s";
            Restart = "on-failure";
            User = "root";
            ExecStart = "${pkgs.tailscale}/bin/tailscale funnel --bg https+insecure://localhost:80";
          };
        };
      };
    };

    virtualisation = {
      docker = {
        enable = true;
        extraOptions = "--storage-driver=vfs";
        autoPrune = {
          enable = true;
          dates = "weekly";
        };
        rootless = {
          enable = false;
          setSocketVariable = true;
        };
      };
      oci-containers = {
        backend = "docker";
        containers = {
          pb-mariadb = {
            image = "mariadb";
            ports = [
              "80:80"
              "443:443"
            ];
            volumes = [ "/nix/persist/passbolt/mariadb:/var/lib/mysql" ];
            environment = {
              MYSQL_RANDOM_ROOT_PASSWORD = "true";
              MYSQL_DATABASE = "passbolt";
              MYSQL_USER = "passbolt";
              MYSQL_PASSWORD = "P4ssb0lt";
            };
          };
          passbolt = {
            image = "passbolt/passbolt:latest-ce";
            dependsOn = [ "pb-mariadb" ];
            #environmentFiles = [ config.age.secrets.seafile-env.path ];
            volumes = [
              "/nix/persist/passbolt/gpg:/etc/passbolt/gpg"
              "/nix/persist/passbolt/jwt:/etc/passbolt/jwt"
            ];
            environment = {
              APP_FULL_BASE_URL = "https://passbolt.local";
              DATASOURCES_DEFAULT_PASSWORD = "passbolt";
              DATASOURCES_DEFAULT_HOST = "127.0.0.1";
              DATASOURCES_DEFAULT_USERNAME = "passbolt";
              DATASOURCES_DEFAULT_DATABASE = "passbolt";
            };
            extraOptions = [ "--network=container:pb-mariadb" ];
          };
        };
      };
    };
  };
}
