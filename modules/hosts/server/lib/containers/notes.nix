{ inputs, lib, ... }:
{
  den.aspects.server.provides.containers.nixos = {
    containers.notes = {
      autoStart = true;
      privateNetwork = true;
      enableTun = true;
      ephemeral = false;
      hostAddress = "192.168.100.1";
      localAddress = "192.168.100.3";
      extraFlags = [ "--private-users-ownership=chown" ];
      additionalCapabilities = [ ''all" --system-call-filter="add_key keyctl bpf" --capability="all'' ];
      bindMounts = {
        "/opt/couchdb/data" = {
          hostPath = "/nix/persist/containers/notes/data";
          isReadOnly = false;
        };
        "/etc/ssh" = {
          hostPath = "/home/victor7w7r/.ssh";
          isReadOnly = true;
        };
        "/web/vaults" = {
          hostPath = "/nix/persist/containers/notes/web/vaults";
          isReadOnly = false;
        };
        "/web/config" = {
          hostPath = "/nix/persist/containers/notes/web/config";
          isReadOnly = false;
        };
      };

      config =
        { config, pkgs, ... }:
        {
          system.stateVersion = "26.05";
          imports = [ inputs.agenix.nixosModules.default ];
          age = {
            identityPaths = [ "/etc/ssh/id_ed25519" ];
            secrets = {
              password-db.file = ../secrets/password-db.age;
              tailnet.file = ../secrets/tailnet.age;
            };
          };
          boot.isContainer = true;
          networking = {
            hostName = "v7w7r-notes";
            firewall.enable = false;
            useHostResolvConf = lib.mkForce false;
          };
          services = {
            resolved.enable = true;
            journald.extraConfig = "SystemMaxUse=100M";
            tailscale = {
              enable = true;
              openFirewall = true;
              useRoutingFeatures = "client";
              authKeyFile = config.age.secrets.tailnet.path;
              extraUpFlags = [
                "--accept-dns=true"
                "--accept-routes"
              ];
            };
            couchdb = {
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
              extraConfigFiles = [ config.age.secrets.password-db.path ];
            };
          };

          systemd = {
            tmpfiles.rules = [
              "d /opt/couchdb/data 0770 couchdb couchdb - -"
              "d /opt/couchdb/etc/local.d 0770 couchdb couchdb - -"
              "d /run/secrets/couchdb-admins.ini 0770 couchdb couchdb - -"
              "d /web/vaults 0770 couchdb couchdb - -"
              "d /web/config 0770 couchdb couchdb - -"
            ];
            services = {
              tailscaled = {
                after = [ "systemd-resolved.service" ];
                wants = [ "systemd-resolved.service" ];
              };
              tailscaled-autoconnect.serviceConfig = lib.mkIf config.boot.isContainer {
                Type = lib.mkForce "exec";
              };
              funnel-client = {
                wantedBy = [ "multi-user.target" ];
                after = [ "tailscaled.service" ];
                wants = [ "tailscaled.service" ];
                serviceConfig = {
                  RestartSec = "5";
                  Restart = "on-failure";
                  User = "root";
                  ExecStart = "${pkgs.tailscale}/bin/tailscale funnel 80";
                };
              };
              funnel-db = {
                wantedBy = [ "multi-user.target" ];
                after = [ "tailscaled.service" ];
                wants = [ "tailscaled.service" ];
                serviceConfig = {
                  RestartSec = "5";
                  Restart = "on-failure";
                  User = "root";
                  ExecStart = "${pkgs.tailscale}/bin/tailscale funnel 5984 --https 8443";
                };
              };
            };
          };

          virtualisation.docker = {
            enable = true;
            autoPrune = {
              enable = true;
              dates = "weekly";
            };
            rootless = {
              enable = false;
              setSocketVariable = true;
            };
          };

          virtualisation.oci-containers.backend = "docker";
          virtualisation.oci-containers.containers."obsidian-web" = {
            image = "docker.io/sytone/obsidian-remote:latest";
            autoStart = true;
            extraOptions = [ "--network=host" ];
            volumes = [
              "/web/vaults:/vaults"
              "/web/config:/config"
            ];
          };
        };
    };

  };
}
