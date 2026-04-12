{ config, inputs, ... }:
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
      "/var/lib/sops-nix/secrets.yaml" = {
        hostPath = "/etc/nixos/nixos/secrets/sec.yaml";
        isReadOnly = true;
      };
      "/var/lib/sops-nix/keys.txt" = {
        hostPath = "/home/victor7w7r/.config/sops/age/keys.txt";
        isReadOnly = true;
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

        imports = [ inputs.sops-nix.nixosModules.sops ];

        sops = {
          defaultSopsFile = "/secrets/sec.yaml";
          validateSopsFiles = false;
          age.keyFile = "/var/lib/sops-nix/keys.txt";
          secrets.password-db = {
            owner = "couchdb";
          };
          templates."couchdb-admins.ini" = {
            owner = "couchdb";
            content = ''
              [admins]
              admin = ${config.sops.placeholder.password-db}
            '';
          };
        };

        services.couchdb = {
          enable = true;
          bindAddress = "0.0.0.0";
          extraConfigFiles = [ "/run/secrets/couchdb-admins.ini" ];
        };

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
