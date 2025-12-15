{ pkgs, ... }:
{
  xserver = {
    enable = true;
    desktopManager.xfce.enable = true;
    excludePackages = with pkgs; [ xterm ];
  };

  security.pam.services.gdm.enableGnomeKeyring = true;

  services = {
    network-manager-applet.enable = true;
    xrdp = {
      enable = true;
      defaultWindowManager = "xfce4-session";
      openFirewall = true;
    };
  };
}
