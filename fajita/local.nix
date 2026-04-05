{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  networking.wireless = {
    enable = true;
    networks."TP-LINK_2.4GHz_FF0A58".psk = "";
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

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
  ];
}
