{ pkgs, username, ... }:
{
  time.timeZone = "America/Guayaquil";
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
    isNormalUser = true;
    description = "${username}";
    shell = pkgs.zsh;
    extraGroups = [
      "audio"
      "input"
      "kvm"
      "libvirtd"
      "libvirt-qemu"
      "networkmanager"
      "power"
      "qemu"
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
    packages = [ pkgs.spleen ];
    earlySetup = true;
    font = "spleen-8x16";
    keyMap = "us";
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
    };

    yazi.enable = true;
    less.enable = true;
    skim.enable = true;
    zsh.enable = true;
  };
}
