{ host, ... }:
{
  networking = {
    hostName = "${host}";
    networkmanager = {
      enable = true;
      settings.main.rc-manager = "resolvconf";
      wifi.powersave = true;
    };
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
        3389
        5900
        9090
      ];
    };
  };
}
