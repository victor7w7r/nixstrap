{
  den.default.nixos =
    {
      isPersistent,
      isServer,
      isPhone,
      isLive,
      lib,
      ...
    }:
    {
      environment = lib.optionalAttrs isPersistent {
        persistence."/nix/persist".directories = lib.mkAfter [
          "/etc/NetworkManager"
          "/var/lib/NetworkManager"
        ];
      };

      networking =
        [
          "8.8.8.8"
          "1.1.1.1"
        ]
        |> (nameservers: {
          inherit nameservers;
          dhcpcd = {
            enable = true;
            wait = "background";
          };
          nat = {
            enable = true;
            internalInterfaces = [
              "incusbr0"
              "virbr0"
            ];
          };
          nftables.enable = true;
          modemmanager.enable = lib.mkForce isPhone;
          networkmanager = {
            enable = true;
            insertNameservers = nameservers;
            dhcp = "dhcpcd";
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
            ];
            allowedTCPPorts = [
              22
              53
              67
              8443
              9090
              (lib.mkIf isServer 8006)
            ];
            allowedUDPPorts = [
              53
              67
            ];
          };
        });

        services = {
          openssh = lib.mkForce {
            enable = true;
            settings = {
              AcceptEnv = null;
              PermitRootLogin = if (isPhone || isLive) then "yes" else lib.mkDefault "prohibit-password";
              PasswordAuthentication = true;
              MaxAuthTries = 3;
              ClientAliveInterval = 300;
              ClientAliveCountMax = 2;
            };
          };
          dnsmasq = {
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
