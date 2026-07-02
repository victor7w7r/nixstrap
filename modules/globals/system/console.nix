{
  den.default.nixos =
    { pkgs, options, ... }:
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
