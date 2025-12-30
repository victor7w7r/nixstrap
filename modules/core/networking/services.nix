{ ... }:
{
  services = {
    #aria2.enable = true; NEEDS KEY
    cockpit.enable = true;
    croc.enable = true;
    dnsmasq.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
    ttyd = {
      enable = true;
      writeable = true;
    };
    #openvpn.package = true;
    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          security = "user";
          workgroup = "WORKGROUP";
          "log file" = "/var/log/samba/%m.log";
          "max log size" = 1000;
          "client min protocol" = "SMB2";
          "server role" = "standalone server";
          "passdb backend" = "tdbsam";
          "obey pam restrictions" = "yes";
          "unix password sync" = "yes";
          "passwd program" = "/usr/bin/passwd %u";
          "passwd chat" =
            "*New*UNIX*password* %n\n *ReType*new*UNIX*password* %n\n *passwd:*all*authentication*tokens*updated*successfully*";
          "pam password change" = "yes";
          "map to guest" = "Bad Password";
          "usershare allow guests" = "yes";
          "name resolve order" = "lmhosts bcast host wins";
          "guest account" = "nobody";
          "usershare path" = "/var/lib/samba/usershare";
          "usershare max shares" = 100;
          "usershare owner only" = "yes";
          "force create mode" = 0070;
          "force directory mode" = 0070;
          "load printers" = "no";
          "printing" = "bsd";
          "printcap name" = "/dev/null";
          "show add printer wizard" = "no";
        };

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
