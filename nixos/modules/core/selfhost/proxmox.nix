{ ... }:
{
  services = {
    resolved.enable = true;
    proxmox-ve = {
      enable = true;
      ipAddress = "192.168.1.100";
      bridges = [ "vmbr0" ];
    };
  };

  networking = {
    useNetworkd = true;
    useDHCP = false;
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  systemd = {
    services = {
      "dhcpcd".enable = false;
      "corosync".enable = false;
      "pvescheduler".enable = false;
      "pvebanner".enable = false;
    };

    network = {
      enable = true;
      networks = {
        "10-lan" = {
          matchConfig.Name = [ "enp1s0" ];
          linkConfig.RequiredForOnline = "yes";
          networkConfig.Bridge = "vmbr0";
        };
        "10-lan-bridge" = {
          matchConfig.Name = "vmbr0";
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

      netdevs."vmbr0".netdevConfig = {
        Name = "vmbr0";
        Kind = "bridge";
      };
    };
  };
}
