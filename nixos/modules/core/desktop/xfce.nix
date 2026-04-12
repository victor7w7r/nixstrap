{ lib, pkgs, ... }:
{
  security.pam.services.gdm.enableGnomeKeyring = true;

  programs = {
    dconf.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };
  };

  services = {
    displayManager.defaultSession = "xfce";
    xserver = {
      enable = lib.mkForce true;
      displayManager.lightdm.enable = false;
      desktopManager.xfce = {
        enable = true;
        enableScreensaver = false;
      };
      xkb = {
        layout = "us";
        variant = "intl-unicode";
      };
      excludePackages = with pkgs; [ xterm ];
    };
    xrdp = {
      enable = true;
      defaultWindowManager = "${pkgs.xfce4-session}/bin/startxfce4";
      openFirewall = true;
    };
  };

  environment.systemPackages = with pkgs; [
    blueman
    deja-dup
    firefox
    font-manager
    pavucontrol
    volumeicon
    xarchiver
    xclip
    xcolor
    xsel
    catfish
    gigolo
    ristretto
    xfce4-appfinder
    xfce4-clipman-plugin
    xfce4-cpufreq-plugin
    xfce4-cpugraph-plugin
    xfce4-fsguard-plugin
    xfce4-genmon-plugin
    xfce4-netload-plugin
    xfce4-notifyd
    xfce4-panel
    xfce4-panel-profiles
    xfce4-pulseaudio-plugin
    xfce4-taskmanager
    xfce4-screenshooter
    xfce4-sensors-plugin
    xfce4-systemload-plugin
    xfce4-whiskermenu-plugin
    xfce4-xkb-plugin
    xfdashboard
    #xfce4-diskperf-plugin
    #xfce4-mount-plugin
    #thunar-extended
    #thunar-custom-actions
    #thunar-shares-plugin
    #gtkhash-thunar
  ];
}
