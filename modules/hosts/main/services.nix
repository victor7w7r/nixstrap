{
  den.aspects.main.services.nixos =
    { pkgs, self', ... }:
    {
      services = {
        fwupd.enable = true;
        thermald.enable = true;
      };
      systemd = {
        services = {
          t2fanrd = {
            enable = true;
            description = "T2FanRD daemon to manage fan curves for T2 Macs";
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Type = "exec";
              ExecStart = "${self'.packages.t2fanrd}/bin/t2fanrd";
              Restart = "always";
              PrivateTmp = true;
              ProtectSystem = true;
              ProtectHome = true;
              ProtectClock = true;
              ProtectHostname = true;
              ProtectControlGroups = true;
              ProtectKernelLogs = true;
              ProtectKernelModules = true;
              ProtectProc = "invisible";
              PrivateDevices = true;
              PrivateNetwork = true;
              NoNewPrivileges = true;
              DevicePolicy = "closed";
              KeyringMode = "private";
              LockPersonality = true;
              MemoryDenyWriteExecute = true;
              PrivateUsers = true;
              RemoveIPC = true;
              RestrictNamespaces = true;
              RestrictRealtime = true;
              RestrictSUIDSGID = true;
              SystemCallArchitectures = "native";
            };
          };
          apple-bce-reload = {
            enable = true;
            description = "Disable and Re-Enable Apple BCE Module";
            wantedBy = [ "sleep.target" ];
            before = [ "sleep.target" ];
            unitConfig.StopWhenUnneeded = true;

            serviceConfig = {
              User = "root";
              Type = "oneshot";
              RemainAfterExit = true;

              ExecStart = [
                "${pkgs.kmod}/bin/modprobe -r brcmfmac_wcc"
                "${pkgs.kmod}/bin/modprobe -r brcmfmac"
                "${pkgs.kmod}/bin/rmmod -f apple-bce"
              ];

              ExecStop = [
                "${pkgs.kmod}/bin/modprobe apple-bce"
                "${pkgs.kmod}/bin/modprobe brcmfmac"
                "${pkgs.kmod}/bin/modprobe brcmfmac_wcc"
              ];
            };
          };
          cache-health-check = {
            serviceConfig = {
              Type = "oneshot";
              ExecStart = pkgs.writeShellScript "bcache-check" ''
                BCACHE_PATH="/sys/block/bcache0/bcache"

                if [ -d "$BCACHE_PATH" ]; then
                  ERRORS=$(cat "$BCACHE_PATH/io_errors" 2>/dev/null || echo "0")
                  STATE=$(cat "$BCACHE_PATH/state" 2>/dev/null || echo "")

                  if [ "$ERRORS" -gt 0 ] || [ "$STATE" = "no cache" ]; then
                    CURRENT_MODE=$(cat "$BCACHE_PATH/cache_mode" | grep -o '\[.*\]' | tr -d '[]')
                    if [ "$CURRENT_MODE" != "writethrough" ] && [ "$CURRENT_MODE" != "passthrough" ]; then
                      echo "Errores detectados ($ERRORS) o estado degrado ($STATE). Conmutando bcache a writethrough..."
                      echo writethrough > "$BCACHE_PATH/cache_mode"
                    fi
                  fi
                fi
              '';
            };
          };
        };

        timers.bcache-health-check = {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnBootSec = "30s";
            OnUnitActiveSec = "10s";
          };
        };
      };
    };
}
