{ lib, ... }:
{
  networking = {
    dhcpcd.enable = true;
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
