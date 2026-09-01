{ containers, ... }:
{
  den.aspects.server.containers.nixos = {

     networking.firewall.allowedTCPPorts = [ 8007 ];

    containers.termix = containers.lib.call {
      ip = "7";
      name = "termix";

      forwardPorts = [
        {
          containerPort = 8080;
          hostPort = 8007;
          protocol = "tcp";
        }
      ];

      bindMounts = {
        "/app/data" = {
          hostPath = "/nix/persist/containers/termix/data";
          isReadOnly = false;
        };
      };

      secrets.tailnet.file = ../secrets/tailnet.age;
      systemd = pkgs: {
        funnel = containers.lib.funnel {
          inherit pkgs;
          incoming = "8080";
        };
      };
      containers = _: {
        termix = {
          image = "lukegus/termix:latest";
          autoStart = true;
          ports = [ "8080:8080" ];
          environment = {
            "PORT" = "8080";
          };
          volumes = [ "termix-data:/app/data" ];
        };
      };
    };
  };
}
