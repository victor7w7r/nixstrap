{ lib, host, ... }:
{
  mobile.boot.stage-1.networking.enable = lib.mkDefault true;
  networking = {
    hostName = "${host}";
    timeServers = [
      "0.south-america.pool.ntp.org"
      "1.south-america.pool.ntp.org"
      "2.south-america.pool.ntp.org"
      "3.south-america.pool.ntp.org"
    ];
    networkmanager = {
      enable = true;
      unmanaged = [
        "rndis0"
        "usb0"
      ];
    };
    wireless.enable = false;
  };
}
