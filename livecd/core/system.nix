{ pkgs, lib, ... }:
with lib;
{
  environment.variables.GC_INITIAL_HEAP_SIZE = "1M";
  environment.etc."systemd/pstore.conf".text = ''
    [PStore]
    Unlink=no
  '';

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

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    nerd-fonts.jetbrains-mono
    nerd-fonts.ubuntu
  ];

  security.sudo = {
    enable = mkDefault true;
    wheelNeedsPassword = mkImageMediaOverride false;
  };

  programs = {
    lazygit.enable = true;
    git.enable = lib.mkDefault true;
    iotop.enable = true;
    less.enable = true;
    usbtop.enable = true;
    zsh.enable = true;
  };

  nix.settings.trusted-users = [
    "root"
    "nixstrap"
  ];

  users.users.nixstrap = {
    root.initialHashedPassword = lib.mkForce "$6$zjvJDfGSC93t8SIW$AHhNB.vDDPMoiZEG3Mv6UYvgUY6eya2UY5E2XA1lF7mOg6nHXUaaBmJYAMMQhvQcA54HJSLdkJ/zdy8UKX3xL1";
    initialHashedPassword = lib.mkForce "$6$zjvJDfGSC93t8SIW$AHhNB.vDDPMoiZEG3Mv6UYvgUY6eya2UY5E2XA1lF7mOg6nHXUaaBmJYAMMQhvQcA54HJSLdkJ/zdy8UKX3xL1";
    isNormalUser = true;
    extraGroups = [
      "input"
      "networkmanager"
      "power"
      "tty"
      "storage"
      "video"
      "wheel"
    ];
  };
}
