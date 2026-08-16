{
  den.aspects.server.services.nixos =
    { pkgs, ... }:
    {
      services = {
        fwupd.enable = true;

        xrdp = {
          enable = true;
          defaultWindowManager = "${pkgs.xfce4-session}/bin/startxfce4";
          openFirewall = true;
        };

        harmonia.cache = {
          enable = false;
          signKeyPaths = [ "/var/lib/secrets/harmonia.secret" ];
        };
        # nix-store --generate-binary-cache-key cache.v7w7r.local \
        #   /nix/persist/var/lib/secrets/harmonia.secret \
        #   /nix/persist/var/lib/secrets/harmonia.pub
        nginx = {
          enable = false;
          recommendedTlsSettings = true;
          virtualHosts."cache.v7w7r.local" = {
            enableACME = false;
            forceSSL = false;
            locations."/".extraConfig = ''
              proxy_pass http://127.0.0.1:5000;
              proxy_set_header Host $host;
              proxy_redirect http:// https://;
              proxy_http_version 1.1;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection $connection_upgrade;
            '';
          };
        };
      };

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
        timers.lvm-snapshot-weekly = {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "weekly";
            Persistent = true;
            Unit = "lvm-snapshot-weekly.service";
          };
        };
      };
    };
}
