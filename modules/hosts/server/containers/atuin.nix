{ containers, ... }: {
  den.aspects.server.containers.nixos = {
    networking.firewall.allowedTCPPorts = [ 8888 ];

    containers.atuin = containers.lib.call {
      ip = "9";
      name = "atuin";
      containers = null;

      forwardPorts = [
        {
          containerPort = 8888;
          hostPort = 8888;
          protocol = "tcp";
        }
      ];

      bindMounts = {
        "/var/lib/atuin" = {
          hostPath = "/nix/persist/containers/atuin/data";
          isReadOnly = false;
        };
        "/var/lib/postgresql" = {
          hostPath = "/nix/persist/containers/atuin/postgresql";
          isReadOnly = false;
        };
      };

      services = _: __: {
        atuin = {
          enable = true;
          host = "0.0.0.0";
          port = 8888;
          openFirewall = true;
          openRegistration = true;
          maxHistoryLength = 99999999;
          database.createLocally = true;
        };
      };
    };
  };
}
