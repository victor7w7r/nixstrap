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
    firewall.allowedTCPPorts = [
      443
      8443
    ];
    useDHCP = false;
    nat = {
      enable = true;
      externalInterface = "br0";
      internalInterfaces = [
        "ve-+"
        "vb-+"
        "brint"
      ];
    };
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  systemd.network = {
    enable = true;
    netdevs = {
      "br0".netdevConfig = {
        Name = "br0";
        Kind = "bridge";
      };
      "20-br-int".netdevConfig = {
        Name = "brint";
        Kind = "bridge";
      };
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

      "20-brint-bridge" = {
        matchConfig.Name = "brint";
        address = [ "10.10.0.1/24" ];
        linkConfig.ActivationPolicy = "always-up";
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
