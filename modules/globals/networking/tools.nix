{
  den.default = {
    os =
      {
        isPersistent,
        isMainMac,
        pkgs,
        self',
        ...
      }:
      {
        environment.systemPackages =
          with pkgs;
          [
            #ariang
            #self'.packages.screego
            curlFull
            doggo
            goto
            gping
            inetutils
            lazyssh
            netscanner
            nmap
            openresolv
            rustscan
            self'.packages.aim
            speedtest-cli
            sshs
            wget
            wol
          ];
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
        environment.systemPackages = with pkgs; [
          axel
          ethtool
          net-tools
          wget2
          slirp4netns
          self'.packages.ssh-list
        ];

        programs = lib.optionalAttrs isPersistent {
          bandwhich.enable = true;
          trippy.enable = true;
        };
      };
  };
}
