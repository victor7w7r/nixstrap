{ lib, ... }:
{
  den.default.nixos =
    {
      isPersistent,
      isServer,
      isPhone,
      ...
    }:
    {
      environment = lib.optionalAttrs (isPersistent || !isServer) {
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
            enable = !isServer;
            insertNameservers = nameservers;
            dhcp = "dhcpcd";
            unmanaged = lib.optionals isPhone [
              "rndis0"
              "usb0"
            ];
          };
          modemmanager.enable = lib.mkForce isPhone;
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
            ++ lib.optionals isServer [ 8006 ];
          };
        });
    };

}
