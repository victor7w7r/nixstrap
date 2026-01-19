{
  pkgs,
  lib,
  options,
  ...
}:
{
  environment = {
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

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    fontconfig = {
      cache32Bit = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [
          "UbuntuMono Nerd Font"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Ubuntu Nerd Font"
          "Noto Color Emoji"
        ];
        serif = [
          "Ubuntu Nerd Font"
          "Noto Color Emoji"
        ];
      };
    };

    packages = with pkgs; [
      nerd-fonts.ubuntu
      nerd-fonts.ubuntu-mono
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };

  security.sudo-rs = {
    enable = lib.mkDefault true;
    wheelNeedsPassword = lib.mkImageMediaOverride false;
  };

  programs = {
    git.enable = lib.mkDefault true;
    nano.enable = false;
    less.enable = true;
    zsh.enable = true;
  };

  users.users = {
    nixstrap = {
      initialHashedPassword = lib.mkForce "$6$zjvJDfGSC93t8SIW$AHhNB.vDDPMoiZEG3Mv6UYvgUY6eya2UY5E2XA1lF7mOg6nHXUaaBmJYAMMQhvQcA54HJSLdkJ/zdy8UKX3xL1";
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
      initialHashedPassword = lib.mkForce "$6$zjvJDfGSC93t8SIW$AHhNB.vDDPMoiZEG3Mv6UYvgUY6eya2UY5E2XA1lF7mOg6nHXUaaBmJYAMMQhvQcA54HJSLdkJ/zdy8UKX3xL1";
      shell = pkgs.zsh;
    };
  };

}
