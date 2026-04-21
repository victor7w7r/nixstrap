{ ... }:
{
  containers.cloud = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br0";
    localAddress = "192.168.1.124/24";
    additionalCapabilities = [
      "CAP_SYS_ADMIN"
      "CAP_NET_ADMIN"
      "CAP_MKNOD"
      "CAP_SYS_CHROOT"
    ];
    forwardPorts = [
      {
        containerPort = 80;
        hostPort = 80;
        protocol = "tcp";
      }
    ];

    bindMounts = {
      "/opt/seafile-mysql/db" = {
        hostPath = "/nix/persist/containers/seafile/mysql";
        isReadOnly = false;
      };
      "/opt/seafile-data" = {
        hostPath = "/nix/persist/cloud";
        isReadOnly = false;
      };
    };

    extraFlags = [
      "--system-call-filter=keyctl"
      "--system-call-filter=bpf"
    ];

    config =
      { pkgs, lib, ... }:
      {
        system.stateVersion = "26.05";
        boot.isContainer = true;

        networking = {
          defaultGateway = "192.168.1.100";
          useHostResolvConf = lib.mkForce false;
          nameservers = [
            "1.1.1.1"
            "8.8.8.8"
          ];
          firewall = {
            enable = true;
            allowedTCPPorts = [
              5984
              8080
              3306
              8443
            ];
          };
        };

        services.resolved.enable = true;

        systemd.services.create-seafile-net = {
          serviceConfig.Type = "oneshot";
          wantedBy = [
            "docker-seafile-mysql.service"
            "docker-seafile.service"
          ];
          script = ''
            check=$(${pkgs.docker}/bin/docker network ls -qf name=seafile-net)
            if [ -z "$check" ]; then
              ${pkgs.docker}/bin/docker network create seafile-net
            fi
          '';
        };

        virtualisation = {
          docker = {
            enable = true;
            daemon.settings = {
              "bridge" = "none";
              "storage-driver" = "vfs";
              dns = [
                "8.8.8.8"
                "1.1.1.1"
              ];
            };
          };
          oci-containers = {
            backend = "docker";
            containers = {
              "seafile-mysql" = {
                image = "mariadb:10.11";
                environment = {
                  MYSQL_ROOT_PASSWORD = "db_dev";
                  MYSQL_LOG_CONSOLE = "true";
                  MARIADB_AUTO_UPGRADE = "1";
                };
                volumes = [
                  "/opt/seafile-mysql/db:/var/lib/mysql"
                ];
                extraOptions = [ "--network=seafile-net" ];
              };

              "seafile-memcached" = {
                image = "memcached:1.6.18";
                cmd = [
                  "memcached"
                  "-m"
                  "256"
                ];
                extraOptions = [ "--network=seafile-net" ];
              };

              "seafile" = {
                image = "seafileltd/seafile-mc:11.0-latest";
                autoStart = true;
                extraOptions = [ "--network=seafile-net" ];
                ports = [ "80:80" ];
                environment = {
                  DB_HOST = "127.0.0.1";
                  DB_ROOT_PASSWD = "db_dev";
                  TIME_ZONE = "America/Guayaquil";
                  SEAFILE_ADMIN_EMAIL = "arkano036@gmail.com";
                  SEAFILE_ADMIN_PASSWORD = "asecret";
                  #SEAFILE_SERVER_HOSTNAME
                  #SEAFILE_SERVER_LETSENCRYPT
                };
                dependsOn = [
                  "seafile-mysql"
                  "seafile-memcached"
                ];
                volumes = [ "/opt/seafile-data:/shared" ];
              };
            };
          };
        };
      };
  };
}
