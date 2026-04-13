{ lib, ... }:
{
  # wol -i 192.168.1.255 00:11:22:33:44:55
  # wol aa:bb:cc:dd:ee:ff
  services.resolved = {
    enable = lib.mkForce true;
    settings.Resolve.DNSStubListener = "no";
  };

  networking = {
    interfaces."enp1s0".wakeOnLan.enable = true;
    useNetworkd = true;
    useDHCP = false;
    trustedInterfaces = [ "ve-+" ];
    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "br0";
    };
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  systemd.network = {
    enable = true;
    netdevs."br0".netdevConfig = {
      Name = "br0";
      Kind = "bridge";
    };
    networks = {
      "10-lan" = {
        matchConfig.Name = [ "enp1s0" ];
        linkConfig.RequiredForOnline = "yes";
        networkConfig.Bridge = "br0";
      };
      "10-lan-bridge" = {
        matchConfig.Name = "br0";
        linkConfig.RequiredForOnline = "routable";
        address = [ "192.168.1.100/24" ];
        gateway = [ "192.168.1.1" ];
        networkConfig = {
          IPv6AcceptRA = true;
          DNS = [
            "1.1.1.1"
            "8.8.8.8"
          ];
        };
      };
    };
  };
}
