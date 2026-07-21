{
  den.default.nixos =
    {
      isPersistent,
      isPhone,
      isServer,
      lib,
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
          inherit nameservers;
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
              (lib.mkIf isServer 8006)
            ];
          };
        });
    };

}
