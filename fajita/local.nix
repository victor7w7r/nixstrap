{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  networking.wireless = {
    enable = true;
    networks."YourWifi".psk = "WifiPW";
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;
    users.root.password = "1234";
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
  ];
}
