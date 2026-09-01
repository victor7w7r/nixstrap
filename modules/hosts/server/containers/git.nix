{ containers, ... }:
{
  den.aspects.server.containers.nixos = {

    firewall.allowedTCPPorts = [ 8004 ];

    containers.git = containers.lib.call {
      ip = "4";
      name = "git";

      forwardPorts = [
        {
          containerPort = 6610;
          hostPort = 8004;
          protocol = "tcp";
        }
      ];

      bindMounts = {
        "/opt/onedev" = {
          hostPath = "/nix/persist/containers/git/data";
          isReadOnly = false;
        };
      };

      systemd = pkgs: {
        funnel = containers.lib.funnel {
          inherit pkgs;
          incoming = "6610";
          incomingTcp = "6611";
          outgoingTcp = "8443";
        };
      };
      containers = _: {
        onedev = {
          image = "1dev/server";
          autoStart = true;
          ports = [
            "6610:6610"
            "6611:6611"
          ];
          environment = {
            # initial_server_url = "https://${builtins.toString networkConfig.publicIp}/onedev/";
          };
          extraOptions = [ "--network=host" ];
          volumes = [
            "onedev:/opt/onedev"
            "/var/run/docker.sock:/var/run/docker.sock"
          ];
        };
      };
    };
  };
}
