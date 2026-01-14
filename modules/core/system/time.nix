{ ... }:
{
  services.chrony = {
    enable = true;
    enableNTS = true;
    servers = [
      "time.cloudflare.com "

      "a.st1.ntp.br"
      "b.st1.ntp.br"
      "c.st1.ntp.br"
      "d.st1.ntp.br"
      "gps.ntp.br"

      "time.bolha.one"

      "ntp3.fau.de"
      "ntp3.ipv6.fau.de"

      "ptbtime1.ptb.de"
      "ptbtime2.ptb.de"
      "ptbtime3.ptb.de"
      "ptbtime4.ptb.de"

      "www.jabber-germany.de"
      "www.masters-of-cloud.de"
      "ntp-by.dynu.net"
      "nts.ntstime.de"

      "ntppool1.time.nl"
      "ntppool2.time.nl"

      "ntpmon.dcs1.biz"

      "nts.netnod.se"
      "gbg1.nts.netnod.se"
      "gbg2.nts.netnod.se"
      "lul1.nts.netnod.se"
      "lul2.nts.netnod.se"
      "mmo1.nts.netnod.se"
      "mmo2.nts.netnod.se"
      "sth1.nts.netnod.se"
      "sth2.nts.netnod.se"
      "svl1.nts.netnod.se"
      "svl2.nts.netnod.se"

      "ntp.3eck.net"
      "ntp.trifence.ch"
      "ntp.zeitgitter.net"
      "time.signorini.ch"

      "virginia.time.system76.com"
      "ohio.time.system76.com"
      "oregon.time.system76.com"
      "paris.time.system76.com"
      "brazil.time.system76.com"

      "stratum1.time.cifelli.xyz"
      "time.cifelli.xyz"
      "time.txryan.com"
    ];
    enableRTCTrimming = true;
    enableMemoryLocking = true;
    directory = "/var/lib/chrony";
    initstepslew = {
      enabled = true;
      threshold = 10;
    };
    extraConfig = ''
      # Only update the local clock if at least four sources are considered
      # good.
      minsources 4

      # Where possible, tell the network interface's hardware to timestamp
      # exactly when packets are received/sent to increase accuracy.
      hwtimestamp *
    '';
  };
}
