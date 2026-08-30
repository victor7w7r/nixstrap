{ containers, ... }:
{
  den.aspects.server.containers.nixos.containers.cloud = containers.lib.call {
    ip = "2";
    name = "cloud";

    bindMounts = {
      "/opt/seafile-mysql/db" = {
        hostPath = "/nix/persist/cloud/seafile/mysql";
        isReadOnly = false;
      };
      "/var/lib/tailscale" = {
        hostPath = "/nix/persist/containers/cloud/tailscale";
        isReadOnly = false;
      };
      "/opt/seafile-data" = {
        hostPath = "/nix/persist/cloud/seafile/shared";
        isReadOnly = false;
      };
    };

    forwardPorts = [
      {
        containerPort = 80;
        hostPort = 8001;
        protocol = "tcp";
      }
    ];
    secrets = {
      seafile-db-env.file = ../secrets/seafile-db-env.age;
      seafile-env.file = ../secrets/seafile-env.age;
      tailnet.file = ../secrets/tailnet.age;
    };

    systemd = pkgs: {
      funnel = containers.lib.funnel {
        inherit pkgs;
        incoming = "80";
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

    containers = config: {
      seafile-db = {
        image = "mariadb:10.11";
        environmentFiles = [ config.age.secrets.seafile-db-env.path ];
        volumes = [ "/opt/seafile-mysql/db:/var/lib/mysql" ];
        extraOptions = [ "--network=seafile-net" ];
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
}
