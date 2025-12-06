{ host, pkgs, ... }:
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
      net-tools
      netscanner
      openresolv
      slirp4netns
      sshs
      speedtest-cli
    ];

  programs = {
    trippy.enable = true;
    bandwhich.enable = true;
  };
}
