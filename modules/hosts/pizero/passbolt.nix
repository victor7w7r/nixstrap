{ inputs, ... }: {
  den.aspects.pizero.passbolt.nixos = { pkgs, ... }: {
    imports = [ inputs.agenix.nixosModules.default ];

    age = {
      identityPaths = [ "/etc/ssh/id_ed25519" ];
    };

    systemd = {
      tmpfiles.rules = [
        "d /nix/persist/passbolt/gpg 0770 1000 1000 - -"
        "d /nix/persist/passbolt/jwt 0770 1000 1000 - -"
        "d /nix/persist/passbolt/mariadb 0770 1000 1000 - -"
      ];

      services = {
        tailscaled.environment.TS_LOG_LEVEL = "0";
        docker.after = [ "systemd-time-wait-sync.service" ];
        tailscaled.after = [ "systemd-time-wait-sync.service" ];
        funnel = {
          wantedBy = [ "multi-user.target" ];
          after = [ "docker.service" ];
          wants = [ "docker.service" ];
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
              "445:443"
            ];
            volumes = [ "/nix/persist/passbolt/mariadb:/var/lib/mysql" ];
            environment = {
              MARIADB_USER = "passbolt";
              MARIADB_PASSWORD = "passbolt";
              MARIADB_DATABASE = "passbolt";
              MARIADB_ROOT_PASSWORD = "root";
            };
          };
          passbolt = {
            image = "passbolt/passbolt";
            dependsOn = [ "pb-mariadb" ];
            #environmentFiles = [ config.age.secrets.seafile-env.path ];
            volumes = [
              "/nix/persist/passbolt/gpg:/etc/passbolt/gpg"
              "/nix/persist/passbolt/jwt:/etc/passbolt/jwt"
            ];
            environment = {
              DATASOURCES_DEFAULT_PASSWORD = "passbolt";
              DATASOURCES_DEFAULT_HOST = "127.0.0.1";
              DATASOURCES_DEFAULT_USERNAME = "passbolt";
              DATASOURCES_DEFAULT_DATABASE = "passbolt";
              APP_FULL_BASE_URL = "https://passbolt.uwuwhatsthis.de";

              EMAIL_TRANSPORT_DEFAULT_HOST = "mx.uwuwhatsthis.de";
              EMAIL_TRANSPORT_DEFAULT_PORT = "587";
              EMAIL_TRANSPORT_DEFAULT_TLS = "true";
              EMAIL_DEFAULT_FROM = "passbolt@uwuwhatsthis.de";
              EMAIL_TRANSPORT_DEFAULT_USERNAME = "passbolt@uwuwhatsthis.de";
            };
            extraOptions = [ "--network=container:pb-mariadb" ];
          };
        };
      };
    };
  };
}
