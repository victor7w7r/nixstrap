{ inputs, lib, ... }:
{
  den.aspects.server.containers.nixos = {
    containers.cloud = {
      autoStart = true;
      privateNetwork = true;
      enableTun = true;
      ephemeral = false;
      hostAddress = "192.168.100.1";
      localAddress = "192.168.100.2";
      extraFlags = [ "--private-users-ownership=chown" ];
      additionalCapabilities = [ ''all" --system-call-filter="add_key keyctl bpf" --capability="all'' ];
      bindMounts = {
        "/opt/seafile-mysql/db" = {
          hostPath = "/nix/persist/cloud/seafile/mysql";
          isReadOnly = false;
        };
        "/etc/ssh" = {
          hostPath = "/home/victor7w7r/.ssh";
          isReadOnly = true;
        };
        "/opt/seafile-data" = {
          hostPath = "/nix/persist/cloud/seafile/shared";
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
              seafile-db-env.file = ../secrets/seafile-db-env.age;
              seafile-env.file = ../secrets/seafile-env.age;
              tailnet.file = ../secrets/tailnet.age;
            };
          };
          boot.isContainer = true;
          networking = {
            hostName = "v7w7r-cloud";
            firewall.enable = false;
            useHostResolvConf = lib.mkForce false;
          };
          services = {
            journald.extraConfig = "SystemMaxUse=100M";
            resolved.enable = true;

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
          };
          systemd = {
            tmpfiles.rules = [ "d /opt/seafile-data 0770 1000 1000 - -" ];
            services = {
              tailscaled-autoconnect.serviceConfig = lib.mkIf config.boot.isContainer {
                Type = lib.mkForce "exec";
              };
              tailscaled = {
                after = [ "systemd-resolved.service" ];
                wants = [ "systemd-resolved.service" ];
              };
              funnel = {
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
              create-seafile-net = {
                serviceConfig.Type = "oneshot";
                wantedBy = [
                  "docker-seafile-db.service"
                  "docker-seafile-cache.service"
                  "docker-seafile.service"
                ];
                script = ''
                  check=$(${pkgs.docker}/bin/docker network ls -qf name=seafile-net)
                  if [ -z "$check" ]; then
                    ${pkgs.docker}/bin/docker network create seafile-net
                  fi
                '';
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
          virtualisation.oci-containers.containers = {
            seafile-db = {
              image = "mariadb:10.11";
              environmentFiles = [ config.age.secrets.seafile-db-env.path ];
              volumes = [ "/opt/seafile-mysql/db:/var/lib/mysql" ];
              extraOptions = [ "--network=seafile-net" ];
            };
            seafile-admin = {
              image = "phpmyadmin";
              ports = [ "8080:80" ];
              environment.PMA_HOST = "seafile-db";
              extraOptions = [ "--network=seafile-net" ];
              dependsOn = [ "seafile-db" ];
            };
            seafile-cache = {
              image = "redis";
              extraOptions = [ "--network=seafile-net" ];
            };
            seafile = {
              image = "seafileltd/seafile-mc:13.0-latest";
              extraOptions = [
                "--network=seafile-net"
                "--dns=8.8.8.8"
                "--privileged"
              ];
              ports = [ "80:80" ];
              volumes = [ "/opt/seafile-data:/shared" ];
              environmentFiles = [ config.age.secrets.seafile-env.path ];
              dependsOn = [
                "seafile-db"
                "seafile-cache"
              ];
            };
          };
        };
    };
  };
}
