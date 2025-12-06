{ host, pkgs, ... }:
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

  environment.systemPackages =
    with pkgs;
    lib.mkAfter [
      doggo
      ethtool
      gping
      hblock
      inetutils
      iptables
      net-tools
      netscanner
      openresolv
      slirp4netns
      sshs
      speedtest-cli
    ];

  services = {

    samba = {
      enable = true;
      openFirewall = true;
      securityType = "user";
      extraConfig = ''
        workgroup = WORKGROUP
        dns proxy = no
        log file = /var/log/samba/%m.log
        max log size = 1000
        client min protocol = SMB2
        server role = standalone server
        passdb backend = tdbsam
        obey pam restrictions = yes
        unix password sync = yes
        passwd program = /usr/bin/passwd %u
        passwd chat = *New*UNIX*password* %n\n *ReType*new*UNIX*password* %n\n *passwd:*all*authentication*tokens*updated*successfully*
        pam password change = yes
        map to guest = Bad Password
        usershare allow guests = yes
        name resolve order = lmhosts bcast host wins
        security = user
        guest account = nobody
        usershare path = /var/lib/samba/usershare
        usershare max shares = 100
        usershare owner only = yes
        force create mode = 0070
        force directory mode = 0070
        load printers = no
        printing = bsd
        printcap name = /dev/null
        disable spoolss = yes
        show add printer wizard = no
      '';
      shares = {
        victor7w7r = {
          path = "/var/lib/Share";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "valid users" = "victor7w7r";
          public = "no";
          writeable = "yes";
        };
      };
    };
  };
}
