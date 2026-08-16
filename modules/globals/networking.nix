{
  den.default = {
    nixos =
      {
        isPersistent,
        isPhone,
        isLive,
        lib,
        pkgs,
        ...
      }:
      {
        environment = lib.optionalAttrs isPersistent {
          persistence."/nix/persist".directories = lib.mkAfter [
            "/etc/NetworkManager"
            "/var/lib/NetworkManager"
          ];
          systemPackages = with pkgs; [
            axel
            ethtool
            net-tools
            wget2
            slirp4netns
            self'.packages.ssh-list
          ];
        };

        networking = {
          nameservers = [
            "8.8.8.8"
            "1.1.1.1"
          ];
          dhcpcd = {
            enable = true;
            wait = "background";
          };
          nftables.enable = true;
          modemmanager.enable = lib.mkForce isPhone;
          networkmanager = {
            enable = true;
            insertNameservers = [
              "8.8.8.8"
              "1.1.1.1"
            ];
            dhcp = "dhcpcd";
          };
        };

        programs = lib.optionalAttrs isPersistent {
          bandwhich.enable = true;
          trippy.enable = true;
        };

        services.openssh = lib.mkForce {
          enable = true;
          settings = {
            AcceptEnv = null;
            PermitRootLogin = if (isPhone || isLive) then "yes" else lib.mkDefault "prohibit-password";
            PasswordAuthentication = true;
            MaxAuthTries = 3;
            ClientAliveInterval = 300;
            ClientAliveCountMax = 2;
          };
        };
      };

    os =
      { pkgs, self', ... }:
      {
        environment.systemPackages = with pkgs; [
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
  };
}
