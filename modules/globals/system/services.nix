{
  den.default.nixos =
    {
      hasVisualKeyboard,
      isPersistent,
      isX86,
      lib,
      pkgs,
      self',
      ...
    }:
    {
      environment.systemPackages =
        with pkgs;
        with self'.packages;
        [
          fatrace
          lazysys
          journalview
          #socktop
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
        irqbalance.enable = false;
        locate.enable = true;
        logrotate.enable = isPersistent;
        nohang = lib.optionalAttrs (!hasVisualKeyboard) { enable = true; };
        orca.enable = lib.mkForce false;
        speechd.enable = false;
        scx.enable = isX86;
        ananicy = lib.optionalAttrs hasVisualKeyboard {
          enable = false;
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
