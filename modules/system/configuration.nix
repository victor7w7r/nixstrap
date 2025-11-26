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
}
