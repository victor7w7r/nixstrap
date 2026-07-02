{ inputs, lib, ... }:
{
  den.aspects.server.provides.containers.nixos = {
    containers.minecraft = {
      autoStart = false;
      privateNetwork = true;
      enableTun = true;
      ephemeral = false;
      hostAddress = "192.168.100.1";
      localAddress = "192.168.100.6";
      extraFlags = [ "--private-users-ownership=chown" ];
      additionalCapabilities = [ ''all" --system-call-filter="add_key keyctl bpf" --capability="all'' ];
      bindMounts = {
        "/etc/ssh" = {
          hostPath = "/home/victor7w7r/.ssh";
          isReadOnly = true;
        };
        "/var/lib/minecraft" = {
          hostPath = "/nix/persist/containers/minecraft";
          isReadOnly = false;
        };
      };
      config =
        { config, pkgs, ... }:
        {
          system.stateVersion = "26.05";
          imports = [ inputs.agenix.nixosModules.default ];
          age = {
            identityPaths = [ "/etc/ssh/id_ed25519" ];
            secrets.tailnet.file = ../secrets/tailnet.age;
          };
          boot.isContainer = true;
          networking = {
            hostName = "v7w7r-mc";
            firewall.enable = false;
            useHostResolvConf = lib.mkForce false;
          };
          services = {
            resolved.enable = true;
            journald.extraConfig = "SystemMaxUse=100M";
            tailscale = {
              enable = true;
              openFirewall = true;
              useRoutingFeatures = "client";
              authKeyFile = config.age.secrets.tailnet.path;
              extraUpFlags = [
                "--accept-dns=true"
                "--accept-routes"
              ];
            };
            minecraft-server = {
              enable = true;
              package = pkgs.papermc;
              openFirewall = true;
              eula = true;
              declarative = true;
              dataDir = "/var/lib/minecraft";
              /*
                whitelist = {
                  username1 = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
                  username2 = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy";
                };
                  AUTOPAUSE_TIMEOUT_EST = "3600"; # 1 Hour
                  AUTOPAUSE_TIMEOUT_INIT = "600"; # 10 Minutes
                  ENABLE_AUTOPAUSE = "TRUE";
                  MAX_TICK_TIME = "-1";
                  TZ = "America/Guayaquil";
              */
              serverProperties = {
                allow-cheats = false;
                allow-flight = true;
                allow-nether = true;
                debug = true;
                enable-rcon = true;
                difficulty = "hard";
                gamemode = 1;
                generate-structures = true;
                level-name = "v7w7r World";
                log-ips = true;
                max-players = 10;
                motd = "NixOS Minecraft server!";
                online-mode = true;
                pvp = true;
                server-port = 25565;
                spawn-animals = true;
                spawn-monsters = true;
                spawn-npcs = true;
                snooper-enabled = true;
                view-distance = "20";
                white-list = true;
              };
              jvmOpts = ''
                -Xms2G
                -Xmx2G
                -XX:+UseG1GC
                -XX:+ParallelRefProcEnabled
                -XX:MaxGCPauseMillis=100
                -XX:+UnlockExperimentalVMOptions
                -XX:+DisableExplicitGC
                -XX:+AlwaysPreTouch
                -XX:G1NewSizePercent=30
                -XX:G1MaxNewSizePercent=40
                -XX:G1HeapRegionSize=8M
                -XX:G1ReservePercent=20
                -XX:G1HeapWastePercent=5
                -XX:G1MixedGCCountTarget=4
                -XX:InitiatingHeapOccupancyPercent=15
                -XX:G1MixedGCLiveThresholdPercent=90
                -XX:G1RSetUpdatingPauseTimePercent=5
                -XX:SurvivorRatio=32
                -XX:+PerfDisableSharedMem
                -XX:MaxTenuringThreshold=1
              '';
            };
          };
          systemd.services = {
            tailscaled = {
              after = [ "systemd-resolved.service" ];
              wants = [ "systemd-resolved.service" ];
            };
            funnel = {
              wantedBy = [ "multi-user.target" ];
              after = [ "tailscaled.service" ];
              wants = [ "tailscaled.service" ];
              serviceConfig = {
                RestartSec = "5";
                Restart = "on-failure";
                User = "root";
                ExecStart = "${pkgs.tailscale}/bin/tailscale funnel --https 443 127.0.0.1:25565";
              };
            };
          };
        };
    };
  };
}
