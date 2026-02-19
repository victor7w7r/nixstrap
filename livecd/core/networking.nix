{ lib, ... }:
{
  systemd.services.NetworkManager-wait-online.enable = false;
  networking = with lib; {
    dhcpcd = {
      enable = true;
      wait = "background";
    };
    hostName = "nixos";
    hosts = {
      "64.16.239.70" = [ "us-central-1.telnyxstorage.com" ];
    };
    timeServers = [
      "0.south-america.pool.ntp.org"
      "1.south-america.pool.ntp.org"
      "2.south-america.pool.ntp.org"
      "3.south-america.pool.ntp.org"
    ];
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
