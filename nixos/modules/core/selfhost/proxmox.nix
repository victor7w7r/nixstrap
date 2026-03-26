{ ... }:
{
  services.proxmox-ve = {
    enable = true;
    ipAddress = "192.168.1.100";
    bridges = [ "vmbr0" ];
  };

  systemd.network = {
    enable = true;
    networks = {
      "10-lan" = {
        matchConfig.Name = [ "enp1s0" ];
        linkConfig.RequiredForOnline = "yes";
        networkConfig = {
          DHCP = "ipv4";
          IPv6AcceptRA = true;
          Bridge = "vmbr0";
        };
      };
      "10-lan-bridge" = {
        matchConfig.Name = "vmbr0";
        linkConfig.RequiredForOnline = "routable";
        networkConfig = {
          DHCP = "ipv4";
          IPv6AcceptRA = true;
        };
      };
    };

    netdevs."vmbr0".netdevConfig = {
      Name = "vmbr0";
      Kind = "bridge";
    };
  };

  systemd.network.wait-online.enable = false;
  systemd.services."dhcpcd".enable = false;
  systemd.services."corosync".enable = false;
  systemd.services."pvestatd".enable = false;
  #systemd.services."pvescheduler".enable = false;
  #systemd.services."pvebanner".enable = false;
  #networking.bridges.vmbr0.interfaces = [ "enp1s0" ];
  #networking.interfaces.vmbr0.useDHCP = lib.mkDefault true;
}
