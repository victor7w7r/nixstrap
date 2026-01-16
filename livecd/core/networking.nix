{ lib, ... }:
with lib;
{
  networking = {
    hostName = "nixos";
    dhcpcd.enable = true;
    networkmanager = {
      enable = true;
      wireless.enable = mkImageMediaOverride true;
      dhcp = "dhcpcd";
    };
    firewall = {
      checkReversePath = "loose";
      enable = true;
      logRefusedConnections = mkDefault false;
      logReversePathDrops = true;
    };
  };
}
