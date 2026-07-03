{ lib, ... }:
{
  den.default.nixos =
    {
      hasVisualKeyboard,
      isHandheld,
      isPersistent,
      isPhone,
      isSuperlab,
      isX86,
      pkgs,
      self',
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        fatrace
        self'.packages.lazysys
        self'.packages.journalview
        self'.packages.socktop
        kmon
        lazyjournal
        lnav
        pik
        s-tui
        systemctl-tui
        sysz
        watchexec
        zps
      ];

      services = {
        journald.extraConfig = ''
          Storage=persistent
          Compress=yes
          MaxLevelStore=debug
          SystemMaxUse=500M
          RuntimeMaxUse=200M
          ForwardToConsole=yes
          MaxLevelConsole=debug
          TTYPath=/dev/ttyS0
        '';

        btrfs.autoScrub = {
          enable = false;
          interval = "weekly";
        };

        snapper = {
          snapshotRootOnBoot = true;
          persistentTimer = true;
        };

        #envfs.enable = true;
        fstrim.enable = true;
        fwupd.enable = hasVisualKeyboard;
        irqbalance.enable = hasVisualKeyboard;
        locate.enable = true;
        logrotate.enable = isPersistent;
        nohang = lib.optionalAttrs (!hasVisualKeyboard) { enable = true; };
        orca.enable = lib.mkForce false;
        scx.enable = isX86;
        speechd.enable = false;
        upower.enable = lib.mkDefault (isHandheld || isPhone || isSuperlab);
        ananicy = lib.optionalAttrs hasVisualKeyboard {
          enable = true;
          package = pkgs.ananicy-cpp;
          rulesProvider = pkgs.ananicy-rules-cachyos;
          extraRules = [
            {
              "name" = "gamescope";
              "nice" = -20;
            }
          ];
        };
        /*
          dbus = {
            packages = with pkgs; [
              nohang
              uresourced
            ];
          };
        */
      };
    };
}
