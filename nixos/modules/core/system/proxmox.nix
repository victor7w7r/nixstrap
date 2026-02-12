{ lib, ... }:
{
  services.proxmox-ve = {
    enable = false;
    ipAddress = "192.168.0.10";
    bridges = [ "vmbr0" ];
  };

  networking.bridges.vmbr0.interfaces = [ "ens18" ];
  networking.interfaces.vmbr0.useDHCP = lib.mkDefault true;
}
