{ lib, pkgs, ... }:
with lib;
{
  imports = [ ./base.nix ];

  isoImage.edition = "xfce";
  powerManagement.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    xe-guest-utilities.enable = false;
    libinput = {
      touchpad = {
        naturalScrolling = true;
        accelProfile = "flat";
        accelSpeed = "0.75";
      };
      mouse.accelProfile = "flat";
    };
    xserver = {
      excludePackages = with pkgs; [ xterm ];
      enable = true;
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          enableScreensaver = false;
        };
      };
      xkb = {
        layout = "us";
        variant = "intl-unicode";
        options = "caps:ctrl_modifier";
      };
      displayManager = {
        autoLogin = {
          enable = true;
          user = "nixstrap";
        };
        lightdm.enable = true;
      };
    };
  };

  virtualisation = {
    vmware.guest.enable = true;
    virtualbox.guest.enable = false;
  };

  environment = {
    sessionVariables.ADW_DEBUG_COLOR_SCHEME = "prefer-dark";
    xfce.excludePackages = with pkgs; [
      gnome-themes-extra
      parole
      pavucontrol
      ristretto
      xfce4-appfinder
      xfce4-notifyd
      xfce4-screensaver
      xfce4-screenshooter
      xfce4-terminal
      xfce4-volumed-pulse
    ];
    defaultPackages = with pkgs; [
      ddrescueview
      gparted
      epiphany
      xarchiver
      xfce4-taskmanager
      xfce4-whiskermenu-plugin
      xfce4-xkb-plugin
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
