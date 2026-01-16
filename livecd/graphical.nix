{ lib, pkgs, ... }:
with lib;
{
  imports = [ ./base.nix ];
  isoImage.edition = "xfce";
  powerManagement.enable = true;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  services = {
    xserver = {
      excludePackages = with pkgs; [ xterm ];
      enable = true;
      desktopManager.xfce = {
        enable = true;
        enableScreensaver = false;
      };
      displayManager = {
        lightdm.enable = true;
        autoLogin = {
          enable = true;
          user = "nixstrap";
        };
      };
    };

    network-manager-applet.enable = true;
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    xe-guest-utilities.enable = pkgs.stdenv.hostPlatform.isx86;
  };

  virtualisation = {
    vmware.guest.enable = pkgs.stdenv.hostPlatform.isx86;
    virtualbox.guest.enable = false;
  };

  environment = {
    defaultPackages = with pkgs; [
      gparted
      firefox
      xarchiver
      xfce.xfce4-cpufreq-plugin
      xfce.xfce4-cpugraph-plugin
      xfce.xfce4-sensors-plugin
      xfce.xfce4-taskmanager
      xfce.xfce4-whiskermenu-plugin
      xfce.xfce4-xkb-plugin
      xfce.xfdashboard
    ];
    pathsToLink = [ "/share/backgrounds" ];
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
}
