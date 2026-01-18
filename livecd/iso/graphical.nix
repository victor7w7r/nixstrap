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

    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    xe-guest-utilities.enable = false;
  };

  virtualisation = {
    vmware.guest.enable = true;
    virtualbox.guest.enable = false;
  };

  environment = {
    defaultPackages = with pkgs; [
      gparted
      mousepad
      firefox
      xarchiver
      xfce4-taskmanager
      xfce4-whiskermenu-plugin
      xfce4-xkb-plugin
      xfdashboard
    ];
    pathsToLink = [ "/share/backgrounds" ];
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
}
