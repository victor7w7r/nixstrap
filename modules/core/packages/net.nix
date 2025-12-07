{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    lib.mkAfter [
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
    ];

  programs = {
    bandwhich.enable = true;
    trippy.enable = true;
  };
}
