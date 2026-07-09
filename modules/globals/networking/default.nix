{
  den.default.nixos =
    { lib, ... }@args:
    {
      environment = lib.optionalAttrs (args.isPersistent || !args.isServer) {
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
          hosts."64.16.239.70" = [ "us-central-1.telnyxstorage.com" ];
          inherit nameservers;
          timeServers = [
            "0.south-america.pool.ntp.org"
            "1.south-america.pool.ntp.org"
            "2.south-america.pool.ntp.org"
            "3.south-america.pool.ntp.org"
          ];
          dhcpcd = {
            enable = true;
            wait = "background";
          };
          networkmanager = {
            enable = !args.isServer;
            insertNameservers = nameservers;
            dhcp = "dhcpcd";
            unmanaged = lib.optionals args.isPhone [
              "rndis0"
              "usb0"
            ];
          };
          modemmanager.enable = lib.mkForce args.isPhone;
          firewall = {
            enable = true;
            allowPing = true;
            checkReversePath = false;
            logRefusedPackets = true;
            logRefusedConnections = false;
            logReversePathDrops = true;
            allowedTCPPorts = [
              22
              9090
            ]
            ++ lib.optionals args.isServer [ 8006 ];
          };
        });
    };

}
