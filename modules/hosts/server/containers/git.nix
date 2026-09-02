{ containers, ... }: {
  den.aspects.server.containers.nixos = {
    networking.firewall.allowedTCPPorts = [ 8004 ];

    containers.git = containers.lib.call {
      ip = "4";
      name = "git";

      forwardPorts = [
        {
          containerPort = 80;
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

      containers = _: {
        onedev = {
          image = "1dev/server";
          autoStart = true;
          ports = [
            "80:6610"
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
