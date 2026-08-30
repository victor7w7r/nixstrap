{
  den.aspects.server.suspend.nixos =
    { pkgs, ... }:
    {
      systemd = {
        timers.auto-sleep-check = {
          enable = false;
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnBootSec = "5m";
            OnUnitActiveSec = "1m";
            Unit = "auto-sleep-check.service";
          };
        };
        timers.lvm-snapshot-weekly = {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "weekly";
            Persistent = true;
            Unit = "lvm-snapshot-weekly.service";
          };
        };
        services = {
          auto-sleep-check = {
            enable = false;
            serviceConfig = {
              Type = "oneshot";
              ExecStart =
                let
                  idleScript = pkgs.writeShellScriptBin "auto-sleep-check" ''
                    MC_PORT=25565
                    IDLE_LIMIT=1800
                    IDLE_FILE="/tmp/server_idle_counter"
                    BLOCKING_PROCS=("nix-build" "rsync" "ffmpeg")

                    for proc in "''${BLOCKING_PROCS[@]}"; do
                        if pgrep -x "$proc" > /dev/null; then
                            echo "$proc is running. Resetting timer."
                            rm -f "$IDLE_FILE"
                            exit 0
                        fi
                    done

                    PLAYER_COUNT=$(ss -Htn sport = :$MC_PORT | grep -c ESTAB)

                    if [ "$PLAYER_COUNT" -gt 0 ]; then
                        echo "$PLAYER_COUNT is online. Resetting timer."
                        rm -f "$IDLE_FILE"
                        exit 0
                    fi

                    if [ ! -f "$IDLE_FILE" ]; then
                        date +%s > "$IDLE_FILE"
                        echo "Starting idle..."
                        exit 0
                    fi

                    START_TIME=$(cat "$IDLE_FILE")
                    CURRENT_TIME=$(date +%s)
                    IDLE_DURATION=$((CURRENT_TIME - START_TIME))

                    if [ "$IDLE_DURATION" -lt "$IDLE_LIMIT" ]; then
                        echo "Is $((IDLE_DURATION / 60)) min from idle. $(((IDLE_LIMIT - IDLE_DURATION) / 60)) min remaining."
                        exit 0
                    fi

                    HOUR=$(date +%H)

                    if [ "$HOUR" -ge 22 ] || [ "$HOUR" -lt 7 ]; then
                        echo "Hibernating..."
                        rm -f "$IDLE_FILE"
                        systemctl hibernate
                    else
                        echo "Suspending..."
                        rm -f "$IDLE_FILE"
                        systemctl suspend
                    fi
                  '';
                in
                "${idleScript}/bin/auto-sleep-check";
            };
          };
          lvm-snapshot-weekly = {
            serviceConfig = {
              Type = "oneshot";
              ExecStart = ''
                /run/current-system/sw/bin/lvcreate \
                  --snapshot --name "snapshot-cloud-$(date +%Y-%m-%d)" \
                  vg0/cloud
              '';
            };
          };
        };
      };
    };
}
