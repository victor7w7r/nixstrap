{
  den.aspects.server.suspend.nixos =
    { pkgs, ... }:
    {
      systemd = {
        timers.auto-sleep-check = {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "*:0/5";
            Persistent = true;
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
            auto-sleep-check = {
              enable = false;
              serviceConfig = {
                Type = "oneshot";
                ExecStart =
                  let
                    idleScript = pkgs.writeShellScriptBin "auto-sleep-check" ''
                      PATH="${pkgs.coreutils}/bin:${pkgs.procps}/bin:${pkgs.systemd}/bin"

                      HOUR=$(date +%H)
                      IDLE_LIMIT=1800
                      IDLE_FILE="/tmp/server_idle_counter"
                      BLOCKING_PROCS=("nix-build" "rsync")

                      if [ "$HOUR" -ge 22 ] || [ "$HOUR" -lt 6 ]; then
                          echo "Horario nocturno alcanzado (22:00 - 06:00). Suspendiendo inmediatamente..."
                          rm -f "$IDLE_FILE"
                          systemctl suspend
                          exit 0
                      fi

                      for proc in "''${BLOCKING_PROCS[@]}"; do
                        if pgrep -x "$proc" > /dev/null; then
                            echo "Proceso $proc corriendo en horario diurno. Reseteando timer."
                            rm -f "$IDLE_FILE"
                            exit 0
                        fi
                      done

                      if [ ! -f "$IDLE_FILE" ]; then
                          date +%s > "$IDLE_FILE"
                          echo "Sin procesos activos en el día. Iniciando temporizador de 30 min..."
                          exit 0
                      fi

                      START_TIME=$(cat "$IDLE_FILE")
                      CURRENT_TIME=$(date +%s)
                      IDLE_DURATION=$((CURRENT_TIME - START_TIME))

                      if [ "$IDLE_DURATION" -lt "$IDLE_LIMIT" ]; then
                          echo "Lleva $((IDLE_DURATION / 60)) min inactivo de día. Faltan $(((IDLE_LIMIT - IDLE_DURATION) / 60)) min para suspender."
                          exit 0
                      fi

                      echo "Servidor inactivo por más de 30 min durante el día. Suspendiendo..."
                      rm -f "$IDLE_FILE"
                      systemctl suspend
                    '';
                  in
                  "${idleScript}/bin/auto-sleep-check";
              };
            };
          };
        };
      };
    };
}
