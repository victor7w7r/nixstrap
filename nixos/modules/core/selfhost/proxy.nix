{ config, ... }:
{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "funnel" = {
        serverName = config.sops.placeholder.tunnel;
        listen = [
          {
            addr = "0.0.0.0";
            port = 443;
            ssl = true;
          }
        ];
        locations = {
          "/" = {
            proxyPass = "https://127.0.0.1:8006";
            proxy_setHeaders = [
              "Host $host"
              "X-Real-IP $remote_addr"
            ];
          };
          "/pc" = {
            proxyPass = "http://127.0.0.1:9090";
            proxy_setHeaders = [
              "Host $host"
              "X-Real-IP $remote_addr"
            ];
          };
          "/chat" = {
            proxyPass = "http://10.10.0.4:8080";
          };
        };
      };

      "funnel-2" = {
        serverName = config.sops.placeholder.tunnel;
        listen = [
          {
            addr = "0.0.0.0";
            port = 8443;
            ssl = true;
          }
        ];
        locations = {
          "/" = {
            proxyPass = "http://10.10.0.2:80";
            proxy_setHeaders = [
              "Host $host"
              "X-Real-IP $remote_addr"
            ];
          };
          "/git" = {
            proxyPass = "http://10.10.0.3:6610";
            proxy_setHeaders = [
              "Host $host"
              "X-Real-IP $remote_addr"
            ];
          };
          "/ssh" = {
            proxyPass = "http://10.10.0.3:6611";
            proxy_setHeaders = [
              "Host $host"
              "X-Real-IP $remote_addr"
            ];
          };
        };
      };

      "funnel-3" = {
        serverName = config.sops.placeholder.tunnel;
        listen = [
          {
            addr = "0.0.0.0";
            port = 10000;
            ssl = true;
          }
        ];
        locations = {
          "/" = {
            proxyPass = "http://10.10.0.3:8080";
            proxy_setHeaders = [
              "Host $host"
              "X-Real-IP $remote_addr"
            ];
          };
          "/db" = {
            #TCP TUNNEL
            proxyPass = "http://10.10.0.3:5984";
            proxy_setHeaders = [
              "Host $host"
              "X-Real-IP $remote_addr"
            ];
          };
          "/mc" = {
            #TCP TUNNEL
            proxyPass = "http://10.10.0.5:25565";
            proxy_setHeaders = [
              "Host $host"
              "X-Real-IP $remote_addr"
            ];
          };
        };
      };
    };
  };
}
