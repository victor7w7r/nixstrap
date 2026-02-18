{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      ariang
      axel
      curlFull
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
      pyload-ng
      #rquickshare
      rustscan
      slirp4netns
      sshs
      speedtest-cli
      wget
      wget2
      (pkgs.callPackage ./custom/aim.nix { })
      (pkgs.callPackage ./custom/goto.nix { })
      #https://github.com/akinoiro/ssh-list
    ]
    ++ [
      nchat
      reader
      stig
      #(pkgs.callPackage ./custom/carbonyl.nix { })
      (pkgs.callPackage ./custom/discli.nix { })
      (pkgs.callPackage ./custom/termishare.nix { })
      #https://github.com/ayn2op/discordo
      #https://github.com/fetchcord/FetchCord
      #https://github.com/sparklost/endcord
      #https://github.com/smmr-software/mabel
      #uv pip install tewi-transmission
      #pkgtop
    ];
}
