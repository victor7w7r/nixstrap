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
            proxy_pass = "https://127.0.0.1:8006";
            proxy_setHeaders = [
              "Host $host"
              "X-Real-IP $remote_addr"
            ];
          };
          "/pc" = {
            proxy_pass = "http://127.0.0.1:9090";
            proxy_setHeaders = [
              "Host $host"
              "X-Real-IP $remote_addr"
            ];
          };
          "/chat" = {
            proxy_pass = "http://10.10.0.4:8080";
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
            proxy_pass = "http://10.10.0.2:80";
            proxy_setHeaders = [
              "Host $host"
              "X-Real-IP $remote_addr"
            ];
          };
          "/git" = {
            proxy_pass = "http://10.10.0.3:6610";
            proxy_setHeaders = [
              "Host $host"
              "X-Real-IP $remote_addr"
            ];
          };
          "/ssh" = {
            proxy_pass = "http://10.10.0.3:6611";
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
            proxy_pass = "http://10.10.0.3:8080";
            proxy_setHeaders = [
              "Host $host"
              "X-Real-IP $remote_addr"
            ];
          };
          "/db" = {
            #TCP TUNNEL
            proxy_pass = "http://10.10.0.3:5984";
            proxy_setHeaders = [
              "Host $host"
              "X-Real-IP $remote_addr"
            ];
          };
          "/mc" = {
            #TCP TUNNEL
            proxy_pass = "http://10.10.0.5:25565";
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
