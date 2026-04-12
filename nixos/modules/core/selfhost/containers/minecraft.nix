{ ... }:
{
  containers.minecraft = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br0";
    localAddress = "192.168.1.121/24";
    forwardPorts = [
      {
        containerPort = 25565;
        hostPort = 25565;
        protocol = "tcp";
      }
    ];
    bindMounts = {
      "/var/lib/minecraft" = {
        hostPath = "/nix/persist/containers/minecraft";
        isReadOnly = false;
      };
    };
    config =
      { pkgs, ... }:
      {
        networking.firewall.allowedTCPPorts = [ 25565 ];
        services.minecraft-server = {
          enable = true;
          package = pkgs.papermc;
          debug = true;
          openFirewall = true;
          eula = true;
          declarative = true;
          dataDir = "/var/lib/minecraft";
          whitelist = {
            username1 = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
            username2 = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy";
          };
          /*
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
  };
}
