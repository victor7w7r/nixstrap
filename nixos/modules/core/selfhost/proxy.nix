{ config, ... }:
{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    virtualHosts = {
      "funnel" = {
        serverName = config.sops.placeholder.tunnel;
        addSSL = false;
        forceSSL = false;
        listen = [
          {
            addr = "127.0.0.1";
            port = 8080;
          }
        ];
        locations = {
          "/" = {
            proxyPass = "https://127.0.0.1:8006";
          };
          "/pc" = {
            proxyPass = "http://127.0.0.1:9090";
          };
          "/chat" = {
            proxyPass = "http://10.10.0.4:8080";
          };
        };
      };

      "funnel-2" = {
        serverName = config.sops.placeholder.tunnel;
        addSSL = false;
        forceSSL = false;
        listen = [
          {
            addr = "127.0.0.1";
            port = 8081;
          }
        ];
        locations = {
          "/" = {
            proxyPass = "http://10.10.0.2:80";
          };
          "/git" = {
            proxyPass = "http://10.10.0.3:6610";
          };
          "/ssh" = {
            proxyPass = "http://10.10.0.3:6611";
          };
        };
      };

      "funnel-3" = {
        serverName = config.sops.placeholder.tunnel;
        addSSL = false;
        forceSSL = false;
        listen = [
          {
            addr = "127.0.0.1";
            port = 8082;
          }
        ];
        locations = {
          "/" = {
            proxyPass = "http://10.10.0.3:8080";
          };
          "/db" = {
            #TCP TUNNEL
            proxyPass = "http://10.10.0.3:5984";
          };
          "/mc" = {
            #TCP TUNNEL
            proxyPass = "http://10.10.0.5:25565";
          };
        };
      };
    };
  };
}
