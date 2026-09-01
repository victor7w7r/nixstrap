{
  den.aspects.firewall = {
    nixos = {
      networking = {
        nat = {
          enable = true;
          internalInterfaces = [
            "ve-+"
            "incusbr0"
            "virbr0"
          ];
        };

        firewall = {
          enable = true;
          allowPing = true;
          checkReversePath = "loose";
          logRefusedPackets = true;
          logRefusedConnections = false;
          logReversePathDrops = true;
          trustedInterfaces = [
            "incusbr0"
            "tailscale0"
            "virbr0"
            "ve-+"
          ];
          extraInputRules = ''iifname "ve-+" accept'';
          allowedTCPPorts = [
            22
            53
            67
            5984
            8000
            8443
            9090
          ];
          allowedUDPPorts = [
            53
            67
          ];
        };
      };

      services.dnsmasq = {
        enable = false;
        settings = {
          interface = [
            "lo"
            "wlp6s0"
            "enp1s0"
            "enp4s0"
          ];
          bind-interfaces = true;
          except-interface = [ "virbr0" ];
        };
      };
    };
  };
}
