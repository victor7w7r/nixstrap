{ lib, ... }:
{
  services.proxmox-ve = {
    enable = true;
    ipAddress = "192.168.1.100";
    bridges = [ "vmbr0" ];
  };

  systemd.services."corosync".enable = false;
  systemd.services."pvestatd".enable = false;
  #systemd.services."pvescheduler".enable = false;
  #systemd.services."pvebanner".enable = false;
  networking.bridges.vmbr0.interfaces = [ "ens18" ];
  networking.interfaces.vmbr0.useDHCP = lib.mkDefault true;
}
