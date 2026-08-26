{
  den.default.nixos =
    {
      hasVisualKeyboard,
      isPersistent,
      isX86,
      lib,
      pkgs,
      options,
      ...
    }:
    {
      environment = {
        enableAllTerminfo = true;
        pathsToLink = [ "/share/applications" ];
        sessionVariables.NIXOS_OZONE_WL = "1";
        variables = {
          LANG = "es_ES.UTF-8";
          LC_ALL = "es_ES.UTF-8";
        };
      };

      time = {
        hardwareClockInLocalTime = false;
        timeZone = "America/Guayaquil";
      };

      console = {
        packages = options.console.packages.default ++ [ pkgs.terminus_font ];
        keyMap = "us-acentos";
      };

      i18n = {
        defaultLocale = "es_ES.UTF-8";
        extraLocales = [ "en_US.UTF-8/UTF-8" ];
        extraLocaleSettings = {
          LC_ADDRESS = "es_ES.UTF-8";
          LC_IDENTIFICATION = "es_ES.UTF-8";
          LC_MEASUREMENT = "es_ES.UTF-8";
          LC_MONETARY = "es_ES.UTF-8";
          LC_NAME = "es_ES.UTF-8";
          LC_NUMERIC = "es_ES.UTF-8";
          LC_PAPER = "es_ES.UTF-8";
          LC_TELEPHONE = "es_ES.UTF-8";
          LC_TIME = "es_ES.UTF-8";
        };
      };

      services = {
        chrony = {
          enable = true;
          initstepslew = {
            enabled = true;
            threshold = 1.0;
          };
          servers = [
            "1.1.1.1"
            "8.8.8.8"
            "time.cloudflare.com"
            "pool.ntp.org"
          ];
        };

        logrotate.enable = isPersistent;
        irqbalance.enable = false;
        orca.enable = lib.mkForce false;
        speechd.enable = false;
        #envfs.enable = true;
        nohang = lib.optionalAttrs (!hasVisualKeyboard) { enable = true; };
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

        journald.extraConfig = ''
          Storage=persistent
          Compress=yes
          MaxLevelStore=debug
          SystemMaxUse=500M
          RuntimeMaxUse=200M
          ForwardToConsole=no
          MaxLevelConsole=debug
          TTYPath=/dev/ttyS0
        '';
      };

      systemd = {
        enableEmergencyMode = true;
        network.wait-online.enable = false;
        settings.Manager = {
          DefaultTimeoutStartSec = "15s";
          DefaultTimeoutStopSec = "10s";
          DefaultTimeoutAbortSec = "5s";
          DefaultLimitNOFILE = "2048:2097152";
        };
      };
    };
}
