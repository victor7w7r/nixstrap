{
  den.aspects.server.services.nixos =
    { pkgs, ... }:
    {
      services = {
        fwupd.enable = true;

        xrdp = {
          enable = true;
          defaultWindowManager =
            with pkgs;
            /*
              [
                dejavu_fonts
                desktop-file-utils
                fontconfig
                garcon
                gsettings-desktop-schemas
                hicolor-icon-theme
                nerd-fonts.ubuntu
                shared-mime-info
                thunar
                tumbler
                xfce4-appfinder
                xfce4-clipman-plugin
                xfce4-cpufreq-plugin
                xfce4-cpugraph-plugin
                xfce4-diskperf-plugin
                xfce4-fsguard-plugin
                xfce4-genmon-plugin
                xfce4-mount-plugin
                xfce4-netload-plugin
                xfce4-panel
                xfce4-panel-profiles
                xfce4-sensors-plugin
                xfce4-session
                xfce4-systemload-plugin
                xfce4-taskmanager
                xfce4-whiskermenu-plugin
                xfce4-xkb-plugin
                xfconf
                xfdesktop
                xfwm4
              ]
              |> (
                paths:
                pkgs.buildEnv {
                  name = "xrdp-xfce-env";
                  inherit paths;
                }
              )
              |> (
              env:
            */
            pkgs.writeShellScript "xrdp-xfce-session" ''
              exec > /tmp/xrdp-debug.log 2>&1
              set -x

              export XDG_SESSION_TYPE=x11
              export XDG_CURRENT_DESKTOP=XFCE
              export DESKTOP_SESSION=xfce
              export GDK_BACKEND=x11
              export QT_QPA_PLATFORM=xcb
              export NIXOS_OZONE_WL=0
              export XDG_RUNTIME_DIR="/run/user/$(id -u)"


              exec ${pkgs.dbus}/bin/dbus-run-session ${pkgs.xfce4-session}/bin/startxfce4
            ''
            #)
            #export FONTCONFIG_FILE="/etc/fonts/fonts.conf"
            #export FONTCONFIG_PATH="/etc/fonts"
            #export GSETTINGS_BACKEND="keyfile"
            #export PATH="${env}/bin:$PATH"
            #export XDG_DATA_DIRS="${env}/share:/run/current-system/sw/share''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
            #export XDG_CONFIG_DIRS="${env}/etc/xdg:/run/current-system/sw/etc/xdg''${XDG_CONFIG_DIRS:+:$XDG_CONFIG_DIRS}"
            |> (session: "exec ${session}");
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
