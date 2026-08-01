{ containers, ... }:
{
  den.aspects.server.provides.containers.nixos.containers.notes = containers.lib.call {
    ip = "3";
    name = "notes";
    rules = [
      "d /opt/couchdb/data 0770 couchdb couchdb - -"
      "d /opt/couchdb/etc/local.d 0770 couchdb couchdb - -"
      "d /run/secrets/couchdb-admins.ini 0770 couchdb couchdb - -"
      "d /web/vaults 0770 couchdb couchdb - -"
      "d /web/config 0770 couchdb couchdb - -"
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
    };

    secrets = {
      password-db.file = ../secrets/password-db.age;
      tailnet.file = ../secrets/tailnet.age;
    };

    services = config: _: {
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

    systemd = pkgs: {
      funnel-client = containers.lib.funnel { inherit pkgs; };
      funnel-db = containers.lib.funnel {
        inherit pkgs;
        incoming = "5984";
        outcoming = "8443";
      };
    };

    containers = _: {
      obsidian-web = {
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
}
