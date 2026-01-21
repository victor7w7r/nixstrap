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
    modemmanager.enable = lib.mkOverride 999 false;
    networkmanager = {
      enable = true;
      insertNameservers = [
        "8.8.8.8"
        "8.8.4.4"
      ];
      dhcp = "dhcpcd";
    };
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
    ];
    wireless.enable = mkImageMediaOverride true;
  };
}
