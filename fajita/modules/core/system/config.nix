{ pkgs, username, ... }:
{
  time = {
    hardwareClockInLocalTime = false;
    timeZone = "America/Guayaquil";
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
  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;
    users = {
      root.password = "1234";
      "${username}" = {
        autoSubUidGidRange = false;
        description = "${username}";
        isNormalUser = true;
        password = "1234";
        uid = 1000;
        extraGroups = [
          "dialout"
          "feedbackd"
          "networkmanager"
          "video"
          "wheel"
        ];
      };
    };
  };

  environment = {
    variables = {
      LANG = "es_ES.UTF-8";
      LC_ALL = "es_ES.UTF-8";
    };
    enableAllTerminfo = true;
  };
  programs = {
    zsh.enable = true;
    less.enable = true;
    skim.enable = true;
  };
}
