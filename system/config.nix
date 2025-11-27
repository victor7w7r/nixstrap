{ pkgs, ... }:

{
  #NixOS
  system.stateVersion = "25.05";
  nix = {
    settings.auto-optimise-store = true;
    settings.allowed-users = [ "victor7w7r" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  #Networking
  networking.networkmanager.enable = true;

  #Locale / Timezone
  services.locate.enable = true;
  time.timeZone = "America/Guayaquil";
  i18n.defaultLocale = "es_ES.UTF-8";
  i18n.extraLocales = [ "en_US.UTF-8/UTF-8" ];
  i18n.extraLocaleSettings = {
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

  #Users
  users.users.victor7w7r = {
    isNormalUser = true;
    initialPassword = "nixstrap";
    extraGroups = [
      "audio"
      "input"
      "kvm"
      "networkmanager"
      "input"
      "power"
      "storage"
      "tty"
      "users"
      "video"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  #Security
  security = {
    rtkit.enable = true;
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  #Audio
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

}
