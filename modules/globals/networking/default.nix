{
  den.default.nixos =
    {
      isPersistent,
      isServer,
      isPhone,
      lib,
      ...
    }:
    {
      environment = lib.optionalAttrs isPersistent {
        persistence."/nix/persist".directories = lib.mkAfter [
          "/etc/NetworkManager/"
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
          nftables.enable = true;
          networkmanager = {
            enable = true;
            insertNameservers = nameservers;
            dhcp = "dhcpcd";
          };
          modemmanager.enable = lib.mkForce isPhone;
          firewall = {
            enable = true;
            allowPing = true;
            checkReversePath = false;
            logRefusedPackets = true;
            logRefusedConnections = false;
            logReversePathDrops = true;
            trustedInterfaces = [ "incusbr0" ];
            allowedTCPPorts = [
              22
              53
              67
              9090
              (lib.mkIf isServer 8006)
            ];
            allowedUDPPorts = [
              53
              67
            ];
          };
        });
    };

}
