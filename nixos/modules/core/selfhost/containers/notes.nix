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
    ];

    bindMounts = {
      "/opt/couchdb/data" = {
        hostPath = "/nix/persist/containers/notes/data";
        isReadOnly = false;
      };
      "/opt/couchdb/etc/local.d" = {
        hostPath = "/nix/persist/containers/notes/etc";
        isReadOnly = false;
      };
      "/run/secrets/couchdb-admins.ini" = {
        hostPath = "/run/secrets/couchdb-admins.ini";
      };
    };

    config =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          curl
          gnugrep
        ];

        networking.firewall.allowedTCPPorts = [ 5984 ];
        system.stateVersion = "26.05";

        services.couchdb = {
          enable = true;
          bindAddress = "0.0.0.0";
          extraConfigFiles = [ "/run/secrets/couchdb-admins.ini" ];
        };

        systemd.tmpfiles.rules = [
          "d /opt/couchdb/data 0770 couchdb couchdb - -"
          "d /opt/couchdb/etc/local.d 0770 couchdb couchdb - -"
          "d /run/secrets/couchdb-admins.ini 0770 couchdb couchdb - -"
        ];

        systemd.services.couchdb-healthcheck = {
          description = "CouchDB Healthcheck";
          script = ''
            ${pkgs.curl}/bin/curl --fail -s -u admin:password http://localhost:5984/_up | ${pkgs.gnugrep}/bin/grep -Eo '"status":"ok"' || exit 1
          '';
          startAt = "*:*:0/30";
        };
      };
  };
}
