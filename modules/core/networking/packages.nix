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
      (pkgs.callPackage ./custom/aim.nix { })
      (pkgs.callPackage ./custom/goto.nix { })
      #https://github.com/akinoiro/ssh-list
    ]
    ++ [
      nchat
      reader
      stig
      (pkgs.callPackage ./custom/updo.nix { })
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
