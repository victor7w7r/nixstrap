{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      ariang
      doggo
      ethtool
      gping
      hblock
      inetutils
      iptables
      lazyssh
      net-tools
      netscanner
      openresolv
      slirp4netns
      sshs
      speedtest-cli
      #https://crates.io/crates/aim
      #https://github.com/grafviktor/goto
      #https://github.com/akinoiro/ssh-list
    ]
    ++ [
      #discordo
      nchat
      reader
      stig
      #https://github.com/smmr-software/mabel
      #uv pip install tewi-transmission
      #https://github.com/Owloops/updo
      #https://github.com/fathyb/carbonyl
      #https://github.com/qnkhuat/termishare
      #https://github.com/wynwxst/DisCli
      #https://github.com/fetchcord/FetchCord
      #https://github.com/sparklost/endcord
      #pkgtop
    ];
}
