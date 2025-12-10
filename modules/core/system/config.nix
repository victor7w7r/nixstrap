{ pkgs, username, ... }:
{
  system.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;

  hardware = {
    ksm.enable = true;
    #sensor.hddtemp.enable = true; SPECIFICATE IN HOSTS with .drives
  };

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

  security = {
    apparmor = {
      enable = true;
      enableCache = true;
    };
    rtkit.enable = true;
    #clamav-gui clamav-unofficial-sigs
    sudo-rs = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 70;
  };

  programs = {
    nix-ld.enable = true;
    nix-ld.libraries = [ ];
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

  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  nixpkgs.config.permittedInsecurePackages = [
    #"ventoy-qt5-1.1.07"
    #"qtwebengine-5.15.19"
  ];

  nix = {
    settings = {
      auto-optimise-store = true;
      allowed-users = [ "${username}" ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
