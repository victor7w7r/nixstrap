{ lib, ... }:
{
  systemd.services.NetworkManager-wait-online.enable = false;
  networking = with lib; {
    dhcpcd = {
      enable = true;
      wait = "background";
    };
    hostName = "nixos";
    firewall = {
      checkReversePath = "loose";
      enable = true;
      logRefusedConnections = mkDefault false;
      logReversePathDrops = true;
    };
    networkmanager = {
      enable = true;
      dhcp = "dhcpcd";
    };
    wireless.enable = mkImageMediaOverride true;
  };
}
