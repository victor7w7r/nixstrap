{ containers, ... }:
{
  den.aspects.server.containers.nixos.containers.termix = containers.lib.call {
    ip = "7";
    name = "termix";
    bindMounts = {
      "/app/data" = {
        hostPath = "/nix/persist/containers/termix";
        isReadOnly = false;
      };
      "/var/lib/tailscale" = {
        hostPath = "/nix/persist/containers/termix/tailscale";
        isReadOnly = false;
      };
    };

    forwardPorts = [
      {
        containerPort = 8080;
        hostPort = 8002;
        protocol = "tcp";
      }
    ];

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
}
