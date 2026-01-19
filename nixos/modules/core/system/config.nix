{ pkgs, username, ... }:
{
  time = {
    hardwareClockInLocalTime = true;
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

  users.users.${username} = {
    autoSubUidGidRange = false;
    description = "${username}";
    group = "users";
    isNormalUser = true;
    initialPassword = "password";
    shell = pkgs.zsh;
    uid = 1000;
    extraGroups = [
      "audio"
      "gamemode"
      "input"
      "kvm"
      "libvirtd"
      "libvirt-qemu"
      "networkmanager"
      "power"
      "qemu"
      "qemu-libvirtd"
      "plugdev"
      "realtime"
      "storage"
      "tty"
      "users"
      "video"
      "wheel"
    ];
  };

  console = {
    enable = true;
    earlySetup = true;
    font = "JetBrainsMono Nerd Font";
    keyMap = "us";
  };

  environment = {
    enableAllTerminfo = true;
    sessionVariables = {
      LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];
      NIXOS_OZONE_WL = "1";
    };
  };

  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    #bash.blesh.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-tty;
    };
    pay-respects.enable = true;
    yazi = {
      enable = true;
      /*
        settings.manager = {
        show_hidden = true;
        show_symlink = true;
        };
      */
    };
    zsh.enable = true;
    less.enable = true;
    skim.enable = true;
  };
}
