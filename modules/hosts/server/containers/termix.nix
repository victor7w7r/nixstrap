{ containers, ... }: {
  den.aspects.server.containers.nixos = {
    networking.firewall.allowedTCPPorts = [ 8007 ];

    containers.termix = containers.lib.call {
      ip = "7";
      name = "termix";

      forwardPorts = [
        {
          containerPort = 80;
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

      containers = _: {
        termix = {
          image = "ghcr.io/lukegus/termix:latest";
          autoStart = true;
          ports = [ "80:8080" ];
          environment = {
            "PORT" = "80";
          };
          volumes = [ "termix-data:/app/data" ];
        };
      };
    };
  };
}
