{
  den.default = {
    os =
      { pkgs, self', ... }@args:
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
          ++ (lib.optionals (args.isPersistent || args.isMainMac) [
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
      { lib, pkgs, ... }@args:
      {
        environment.systemPackages =
          with pkgs;
          [
            ethtool
            iptables
            net-tools
            wget2
          ]
          ++ (lib.optionals (args.isPersistent || args.isMainMac) [
            #ariang
            slirp4netns
            rquickshare
            args.self'.packages.ssh-list
          ]);

        programs = lib.optionalAttrs args.isPersistent {
          bandwhich.enable = true;
          trippy.enable = true;
        };
      };
  };
}
