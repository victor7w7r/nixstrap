{ inputs, ... }:
{
  flake-file.inputs.proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";

  den.aspects.server.default.nixos =
    { pkgs, ... }:
    {
      imports = [ inputs.proxmox-nixos.nixosModules.proxmox-ve ];

      environment.systemPackages = with pkgs; [
        iproute2
        procps
      ];

      services = {
        proxmox-ve = {
          enable = true;
          ipAddress = "192.168.1.100";
          bridges = [ "br0" ];
        };
        xrdp = {
          enable = true;
          defaultWindowManager = "${pkgs.xfce4-session}/bin/startxfce4";
          openFirewall = true;
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
          "dhcpcd".enable = false;
          "corosync".enable = false;
          "pvescheduler".enable = false;
          "pvebanner".enable = false;

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
        };
      };
    };
}
