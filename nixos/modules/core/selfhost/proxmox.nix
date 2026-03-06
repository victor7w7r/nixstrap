{ lib, ... }:
{
  services.proxmox-ve = {
    enable = true;
    ipAddress = "192.168.1.100";
    bridges = [ "vmbr0" ];
  };

  systemd.services."dhcpcd".enable = false;
  systemd.services."corosync".enable = false;
  systemd.services."pvestatd".enable = false;
  systemd.network.wait-online.enable = false;
  systemd.services."sys-subsystem-net-devices-ens18.device".enable = false;
  #systemd.services."pvescheduler".enable = false;
  #systemd.services."pvebanner".enable = false;
  networking.bridges.vmbr0.interfaces = [ "ens18" ];
  networking.interfaces.vmbr0.useDHCP = lib.mkDefault true;
}
