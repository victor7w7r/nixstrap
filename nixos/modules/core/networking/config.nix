{
  lib,
  host,
  ...
}:
{
  networking = {
    hostName = "${host}";
    hostId = "314e119c";
    hosts = {
      "64.16.239.70" = [ "us-central-1.telnyxstorage.com" ];
    };
    timeServers = [
      "0.south-america.pool.ntp.org"
      "1.south-america.pool.ntp.org"
      "2.south-america.pool.ntp.org"
      "3.south-america.pool.ntp.org"
    ];
    networkmanager = {
      enable = true;
      settings.main.rc-manager = "resolvconf";
      wifi.powersave = true;
    };
    /*
      wireless = {
      secretsFile = config.sops.secrets.wireless.path;
      networks = {
        "TP-LINK_5GHz_FF0A59".pskRaw = "ext:pass_main";
        "v7w7r-dir615".pskRaw = "ext:pass_tech";
      };
      };
    */
    modemmanager.enable = lib.mkOverride 999 false;
    resolvconf = {
      enable = true;
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
      #allowedUDPPorts = [ 59010 59011 53317 4501 5353 ];
      allowedTCPPorts = [
        22
        53
        67
        80
        443
        3389
        5900
        9090
      ];
    };
  };

  programs = {
    bandwhich.enable = true;
    trippy.enable = true;
  };
}
