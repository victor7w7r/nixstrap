{ config, ... }:
{
  /*
    services:
      db:
        image: mariadb:10.11
        container_name: seafile-mysql
        environment:
          - MYSQL_ROOT_PASSWORD=db_dev  # Required, set the root's password of MySQL service.
          - MYSQL_LOG_CONSOLE=true
          - MARIADB_AUTO_UPGRADE=1
        volumes:
          - /opt/seafile-mysql/db:/var/lib/mysql  # Required, specifies the path to MySQL data persistent store.
        networks:
          - seafile-net

      memcached:
        image: memcached:1.6.18
        container_name: seafile-memcached
        entrypoint: memcached -m 256
        networks:
          - seafile-net

      seafile:
        image: seafileltd/seafile-mc:11.0-latest
        container_name: seafile
        ports:
          - "80:80"
    #     - "443:443"  # If https is enabled, cancel the comment.
        volumes:
          - /opt/seafile-data:/shared   # Required, specifies the path to Seafile data persistent store.
        environment:
          - DB_HOST=db
          - DB_ROOT_PASSWD=db_dev  # Required, the value should be root's password of MySQL service.
          - TIME_ZONE=Etc/UTC  # Optional, default is UTC. Should be uncomment and set to your local time zone.
          - SEAFILE_ADMIN_EMAIL=me@example.com # Specifies Seafile admin user, default is 'me@example.com'.
          - SEAFILE_ADMIN_PASSWORD=asecret     # Specifies Seafile admin password, default is 'asecret'.
          - SEAFILE_SERVER_LETSENCRYPT=false   # Whether to use https or not.
          - SEAFILE_SERVER_HOSTNAME=docs.seafile.com # Specifies your host name if https is enabled.
        depends_on:
          - db
          - memcached
        networks:
          - seafile-net

    networks:
      seafile-net:
  */

  containers.cloud = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br0";
    localAddress = "192.168.1.124/24";

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

    };

    extraFlags = [
      "--system-call-filter=keyctl"
      "--system-call-filter=bpf"
    ];
  };

  config =
    { lib, ... }:
    {
      system.stateVersion = "26.05";
      boot.isContainer = true;
      networking = {
        useHostResolvConf = lib.mkForce false;
        nameservers = [
          "192.168.1.1"
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

      virtualisation = {
        docker.enable = true;
        oci-containers = {
          backed = "docker";
          containers = {
            db = { };
            memcached = { };
            seafile = {
              image = "seafileltd/seafile-mc:latest";
              environment = {
                TIME_ZONE = "America/Guayaquil";
                #SEAFILE_SERVER_HOSTNAME = "seafile.arsfeld.one";
                #SEAFILE_SERVER_PROTOCOL = "https";
                DB_HOST = "host.containers.internal";
                DB_ROOT_PASSWD = "";
                SEAFILE_ADMIN_EMAIL = "test@test.com";
                SEAFILE_ADMIN_PASSWORD = "test";
                SEAFILE_SERVER_LETSENCRYPT = false;
                SEAFILE_MYSQL_DB_USER = "seafile";
              };
              environmentFiles = [ config.sops.secrets.seafile-env.path ];
              volumes = [ "/nix/persist/cloud:/shared" ];
              ports = [
                "80:80"
                "443:443"
              ];
              extraOptions = [ "--add-host=host.containers.internal:host-gateway" ];
            };
          };
        };
      };
    };
}
