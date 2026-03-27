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
        networkConfig.Bridge = "vmbr0";
      };
      "10-lan-bridge" = {
        matchConfig.Name = "vmbr0";
        linkConfig.RequiredForOnline = "routable";
        address = [ "192.168.1.100/24" ];
        gateway = [ "192.168.1.1" ];
        dns = [
          "1.1.1.1"
          "8.8.8.8"
        ];
        networkConfig.IPv6AcceptRA = true;
      };
    };

    netdevs."vmbr0".netdevConfig = {
      Name = "vmbr0";
      Kind = "bridge";
    };
  };

  systemd.services."pvestatd".enable = true;
  systemd.services."dhcpcd".enable = false;
  systemd.services."corosync".enable = true;
  #systemd.services."pvescheduler".enable = false;
  #systemd.services."pvebanner".enable = false;
}
