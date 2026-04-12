{ ... }:
{
  containers.notes = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br0";
    localAddress = "192.168.1.120/24";
    forwardPorts = [
      {
        containerPort = 5984;
        hostPort = 5984;
        protocol = "tcp";
      }
      {
        containerPort = 8080;
        hostPort = 8080;
        protocol = "tcp";
      }
      {
        containerPort = 8443;
        hostPort = 8443;
        protocol = "tcp";
      }
    ];

    bindMounts = {
      "/opt/couchdb/data" = {
        hostPath = "/nix/persist/containers/notes/data";
        isReadOnly = false;
      };
      "/web/vaults" = {
        hostPath = "/nix/persist/containers/notes/web/vaults";
        isReadOnly = false;
      };
      "/web/config" = {
        hostPath = "/nix/persist/containers/notes/web/config";
        isReadOnly = false;
      };
      "/run/secrets/rendered/couchdb-admins.ini" = {
        hostPath = "/run/secrets/rendered/couchdb-admins.ini";
      };
    };

    config =
      { pkgs, ... }:
      {
        system.stateVersion = "26.05";
        boot.isContainer = true;
        networking = {
          nftables.enable = true;
          firewall.allowedTCPPorts = [
            5984
            8080
            8443
          ];
        };
        services.couchdb = {
          enable = true;
          bindAddress = "0.0.0.0";
          extraConfig = {
            couchdb = {
              single_node = true;
              max_http_request_size = 4294967296;
              max_document_size = 50000000;
            };

            chttpd = {
              require_valid_user = true;
              max_http_request_size = 4294967296;
              enable_cors = true;
            };

            chttpd_auth = {
              require_valid_user = true;
              authentication_redirect = "/_utils/session.html";
            };

            httpd = {
              WWW-Authenticate = ''Basic realm="couchdb"'';
              enable_cors = true;
              bind_address = "0.0.0.0";
            };

            cors = {
              origins = "app://obsidian.md, capacitor://localhost, http://localhost";
              credentials = true;
              headers = "accept, authorization, content-type, origin, referer";
              methods = "GET,PUT,POST,HEAD,DELETE";
              max_age = 3600;
            };

          };
          extraConfigFiles = [ "/run/secrets/couchdb-admins.ini" ];
        };

        environment.systemPackages = with pkgs; [
          curl
          gnugrep
        ];

        systemd = {
          tmpfiles.rules = [
            "d /opt/couchdb/data 0770 couchdb couchdb - -"
            "d /opt/couchdb/etc/local.d 0770 couchdb couchdb - -"
            "d /run/secrets/couchdb-admins.ini 0770 couchdb couchdb - -"
          ];
          services.couchdb-healthcheck = {
            description = "CouchDB Healthcheck";
            startAt = "*:*:0/30";
            script = ''
              ${pkgs.curl}/bin/curl --fail -s -u admin:password http://localhost:5984/_up \
              | ${pkgs.gnugrep}/bin/grep -Eo '"status":"ok"' || exit 1
            '';
          };
        };

        virtualisation = {
          docker.enable = true;
          oci-containers = {
            backend = "docker";
            containers."obsidian-web" = {
              image = "ghcr.io/sytone/obsidian-remote:latest";
              autoStart = true;
              environment = { };
              ports = [
                "8080:8080"
                "8443:8443"
              ];
              volumes = [
                "/web/vaults:/vaults"
                "/web/config:/config"
              ];
            };
          };
        };
      };
  };
}
