{ ... }:
{
  containers.cloud = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br0";
    localAddress = "192.168.1.124/24";

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
            package = pkgs.mariadb;
            initialRootPassword = "db_dev";
            settings = {
              mysqld = {
                log_console = true;
              };
            };
          };
        };
      };

    virtualisation = {
      docker = {
        enable = true;
        daemon.settings = {
          "bridge" = "none";
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
          environment = {
            DB_HOST = "db";
            DB_ROOT_PASSWD = "db_dev";
            TIME_ZONE = "America/Guayaquil";
            SEAFILE_ADMIN_EMAIL = "me@example.com";
            SEAFILE_ADMIN_PASSWORD = "asecret";
            #SEAFILE_SERVER_HOSTNAME
            #SEAFILE_SERVER_LETSENCRYPT
          };
          ports = [
            "80:80"
            "443:443"
          ];
          volumes = [ "/opt/seafile-data:/shared" ];
        };
      };
    };
  };
}
