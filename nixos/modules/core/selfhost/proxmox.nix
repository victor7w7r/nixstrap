{ lib, ... }:
{
  services.proxmox-ve = {
    enable = true;
    ipAddress = "192.168.1.100";
    bridges = [ "vmbr0" ];
  };

  networking.bridges.vmbr0.interfaces = [ "ens18" ];
  networking.interfaces.vmbr0.useDHCP = lib.mkDefault true;
}
