{
  pkgs,
  flavor,
  lib,
  options,
  ...
}:
{
  system = with lib; {
    extraDependencies = mkForce [
      pkgs.stdenvNoCC
      pkgs.jq
      pkgs.busybox
      pkgs.makeInitrdNGTool
    ];
    nixos.variant_id = mkDefault flavor;
    stateVersion = "24.05";
  };

  environment = {
    defaultPackages = lib.mkDefault [ ];
    variables.GC_INITIAL_HEAP_SIZE = "1M";
    stub-ld.enable = false;
    etc."systemd/pstore.conf".text = ''
      [PStore]
      Unlink=no
    '';
  };

  console = {
    packages = options.console.packages.default ++ [ pkgs.terminus_font ];
    keyMap = "us-acentos";
  };

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

  security = {
    polkit.enable = true;
    sudo-rs = {
      enable = lib.mkDefault true;
      wheelNeedsPassword = lib.mkImageMediaOverride false;
    };
  };

  programs = with lib; {
    git.enable = true;
    nano.enable = false;
    less.enable = true;
    zsh.enable = true;
    command-not-found.enable = mkDefault false;
    fish.generateCompletions = mkDefault false;
  };

  users.users = with lib; {
    nixstrap = {
      initialHashedPassword = mkForce "$6$zjvJDfGSC93t8SIW$AHhNB.vDDPMoiZEG3Mv6UYvgUY6eya2UY5E2XA1lF7mOg6nHXUaaBmJYAMMQhvQcA54HJSLdkJ/zdy8UKX3xL1";
      isNormalUser = true;
      shell = pkgs.zsh;
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
    root = {
      initialHashedPassword = mkForce "$6$zjvJDfGSC93t8SIW$AHhNB.vDDPMoiZEG3Mv6UYvgUY6eya2UY5E2XA1lF7mOg6nHXUaaBmJYAMMQhvQcA54HJSLdkJ/zdy8UKX3xL1";
      shell = pkgs.zsh;
    };
  };

}
