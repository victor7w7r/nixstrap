{ lib, ... }:
{
  den.aspects.server.networking.nixos = {
    # wol -i 192.168.1.255 00:11:22:33:44:55
    # wol aa:bb:cc:dd:ee:ff
    services = {
      network-manager-applet.enable = true;
      resolved = {
        enable = lib.mkForce true;
        settings.Resolve.DNSStubListener = "no";
      };
    };

    networking = {
      useNetworkd = true;
      useDHCP = false;
      interfaces."enp1s0".wakeOnLan.enable = true;
      firewall = {
        trustedInterfaces = [
          "vb-+"
          "ve-+"
          "br0"
        ];
      };
      nat = {
        enable = true;
        externalInterface = "br0";
        internalInterfaces = [
          "ve-+"
          "vb-+"
        ];
      };
      nameservers = [
        "1.1.1.1"
        "8.8.8.8"
      ];
    };

    systemd.network = {
      enable = true;
      netdevs."br0" = {
        netdevConfig = {
          Name = "br0";
          Kind = "bridge";
        };
      };

      networks = {
        "10-lan" = {
          matchConfig.Name = "enp1s0";
          networkConfig.Bridge = "br0";
        };
        "10-lan-bridge" = {
          matchConfig.Name = "br0";
          linkConfig.RequiredForOnline = "no";
          bridgeConfig = { };
          networkConfig.ConfigureWithoutCarrier = true;
          address = [ "192.168.1.100/24" ];
          gateway = [ "192.168.1.1" ];
        };
      };
    };
  };
}
