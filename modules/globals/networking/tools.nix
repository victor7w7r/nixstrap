{
  den.default = {
    os =
      {
        isMainMac,
        isPersistent,
        pkgs,
        self',
        ...
      }:
      {
        environment.systemPackages =
          with pkgs;
          [
            curlFull
            gping
            inetutils
            wget
            wol
          ]
          ++ (lib.optionals (isPersistent || isMainMac) [
            #ariang
            doggo
            goto
            lazyssh
            netscanner
            openresolv
            rustscan
            sshs
            speedtest-cli
            self'.packages.aim
          ]);
      };

    provides.to-users.homeManager =
      { isPersistent, pkgs, ... }:
      {
        home.packages = with pkgs; [ axel ];
        programs.himalaya.enable = isPersistent;
      };

    nixos =
      {
        isPersistent,
        lib,
        pkgs,
        self',
        ...
      }:
      {
        environment.systemPackages =
          with pkgs;
          [
            ethtool
            iptables
            net-tools
            wget2
          ]
          ++ (lib.optionals (isPersistent || isMainMac) [
            #ariang
            slirp4netns
            rquickshare
            self'.packages.ssh-list
          ]);

        programs = lib.optionalAttrs isPersistent {
          bandwhich.enable = true;
          trippy.enable = true;
        };
      };
  };
}
