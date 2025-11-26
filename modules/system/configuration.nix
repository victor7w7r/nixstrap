{
  config,
  pkgs,
  inputs,
  ...
}:

{
  networking.networkmanager.enable = true;
  users.users.victor7w7r = {
    isNormalUser = true;
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

  services.locate.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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
}
