{
  den.aspects.server.services.atuin.nixos = { lib, ... }: {

    environment.persistence."/nix/persist".directories = lib.mkAfter [
      "/var/lib/atuin"
      "/var/lib/postgresql"
    ];

    services.atuin = {
      enable = true;
      host = "0.0.0.0";
      port = 8888;
      openFirewall = true;
      openRegistration = true;
      maxHistoryLength = 99999999;
      database.createLocally = true;
    };

    networking.firewall = {
      allowedTCPPorts = [ 8888 ];
      interfaces."tailscale0".allowedTCPPorts = [ 8888 ];
    };
  };
}
