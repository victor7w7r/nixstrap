{ inputs, ... }: {
  den.aspects.pizero.passbolt.nixos = {
    imports = [ inputs.agenix.nixosModules.default ];

    networking.firewall = {
      allowedTCPPorts = [ 80 ];
      interfaces."tailscale0".allowedTCPPorts = [ 80 ];
    };

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

      /*
        docker exec passbolt su -m -c "/usr/share/php/passbolt/bin/cake \
          passbolt register_user \
            -u YOUR_EMAIL \
            -f YOUR_NAME \
            -l YOUR_LASTNAME \
            -r admin" -s /bin/sh www-data
      */

      oci-containers = {
        backend = "docker";
        containers = {
          passbolt-db = {
            image = "mariadb:10.11";
            volumes = [ "/nix/persist/passbolt/mariadb:/var/lib/mysql" ];
            ports = [ "80:80" ];
            environment = {
              MYSQL_DATABASE = "passbolt";
              MYSQL_PASSWORD = "P4ssb0lt";
              MYSQL_RANDOM_ROOT_PASSWORD = "true";
              MYSQL_USER = "passbolt";
            };
          };
          passbolt = {
            image = "passbolt/passbolt:latest-ce";
            dependsOn = [ "passbolt-db" ];
            cmd = [
              "/usr/bin/wait-for.sh"
              "-t"
              "0"
              "127.0.0.1:3306"
              "--"
              "/docker-entrypoint.sh"
            ];
            volumes = [
              "/nix/persist/passbolt/gpg:/etc/passbolt/gpg"
              "/nix/persist/passbolt/jwt:/etc/passbolt/jwt"
            ];
            environment = {
              APP_FULL_BASE_URL = "http://passbolt.local";
              DATASOURCES_DEFAULT_PASSWORD = "P4ssb0lt";
              DATASOURCES_DEFAULT_HOST = "127.0.0.1";
              DATASOURCES_DEFAULT_USERNAME = "passbolt";
              DATASOURCES_DEFAULT_DATABASE = "passbolt";
            };
            extraOptions = [ "--network=container:passbolt-db" ];
          };
        };
      };
    };
  };
}
