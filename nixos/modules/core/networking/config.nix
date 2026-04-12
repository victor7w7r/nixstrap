{
  lib,
  system,
  host,
  ...
}:
{
  networking = {
    hostName = "${host}";
    hostId = "314e119c";
    hosts."64.16.239.70" = [ "us-central-1.telnyxstorage.com" ];
    timeServers = [
      "0.south-america.pool.ntp.org"
      "1.south-america.pool.ntp.org"
      "2.south-america.pool.ntp.org"
      "3.south-america.pool.ntp.org"
    ];
    networkmanager = {
      enable = host != "v7w7r-youyeetoox1" && system != "aarch64-linux";
      settings.main.rc-manager = "resolvconf";
      wifi.powersave = host != "v7w7r-higole";
      unmanaged =
        [ ]
        ++ (
          if host == "v7w7r-fajita" then
            [
              "rndis0"
              "usb0"
            ]
          else
            [ ]
        );
    };
    modemmanager.enable = lib.mkOverride 999 false;
    resolvconf = {
      enable = host != "v7w7r-youyeetoox1";
      useLocalResolver = true;
      dnsExtensionMechanism = false;
      extraConfig = ''
        local_nameservers=""
        name_server_blacklist="0.0.0.0 127.0.0.1"
        resolv_conf_local_only=NO
      '';
    };
    firewall = {
      allowPing = true;
      enable = true;
      logRefusedPackets = true;
      allowedTCPPorts = [
        22
        53
        67
        80
        443
        2222
        8006
        3389
        5984
        5900
        9090
        10080
        25565
      ];
    };
  };

  programs = {
    bandwhich.enable = true;
    trippy.enable = true;
  };
}
