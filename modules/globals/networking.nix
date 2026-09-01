{
  den.default = {
    nixos =
      {
        isPersistent,
        isPhone,
        isLive,
        lib,
        pkgs,
        self',
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
          extraHosts = ''
            192.168.100.11 passbolt.local
            100.64.0.4 passbolt.local
          '';
          dhcpcd = {
            enable = true;
            wait = "background";
          };
          nftables = {
            enable = true;
            ruleset = ''
              table ip custom_nat {
                chain postrouting {
                  type nat hook postrouting priority srcnat; policy accept;
                  oifname "enp1s0" ip saddr 10.200.0.0/16 masquerade
                }
              }
            '';
          };
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
          iptables
          lazyssh
          netscanner
          nmap
          openresolv
          rustscan
          self'.packages.aim
          speedtest-cli
          sshs
          tcpdump
          wget
          wol
        ];
      };
  };
}
