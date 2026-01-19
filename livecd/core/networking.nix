{ lib, ... }:
{
  systemd.services.NetworkManager-wait-online.enable = false;
  networking = {
    dhcpcd = {
      enable = true;
      wait = "background";
    };
    hostName = "nixos";
    firewall = {
      checkReversePath = "loose";
      enable = true;
      logRefusedConnections = lib.mkDefault false;
      logReversePathDrops = true;
    };
    networkmanager = {
      enable = true;
      dhcp = "dhcpcd";
    };
    wireless.enable = lib.mkImageMediaOverride true;
  };
}
