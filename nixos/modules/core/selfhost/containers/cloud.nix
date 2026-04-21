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
      "/var/lib/mysql" = {
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

        services = {
          resolved.enable = true;
          memcached = {
            enable = true;
            maxMemory = 256;
          };
          mysql = {
            enable = true;
            package = pkgs.mariadb_1011.override { withPam = false; };
            initialScript = pkgs.writeText "init-sql" ''
              ALTER USER 'root'@'localhost' IDENTIFIED BY 'db_dev';
              CREATE DATABASE IF NOT EXISTS seafile_db;
              FLUSH PRIVILEGES;
            '';
            ensureUsers = [
              {
                name = "seafile_user";
                ensurePermissions = {
                  "seafile_db.*" = "ALL PRIVILEGES";
                };
              }
            ];
            settings.mysqld = {
              innodb_use_native_aio = 0;
              bind-address = "0.0.0.0";
              log_console = true;
            };
          };
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
            containers."seafile" = {
              image = "seafileltd/seafile-mc:11.0-latest";
              autoStart = true;
              extraOptions = [ "--network=host" ];
              environment = {
                DB_HOST = "127.0.0.1";
                DB_ROOT_PASSWD = "db_dev";
                TIME_ZONE = "America/Guayaquil";
                SEAFILE_ADMIN_EMAIL = "arkano036@gmail.com";
                SEAFILE_ADMIN_PASSWORD = "asecret";
                #SEAFILE_SERVER_HOSTNAME
                #SEAFILE_SERVER_LETSENCRYPT
              };
              volumes = [ "/opt/seafile-data:/shared" ];
            };
          };
        };
      };
  };
}
