{ pkgs, ... }:
{
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
    xfce.catfish
    xfce.gigolo
    xfce.ristretto
    xfce.xfce4-appfinder
    xfce.xfce4-clipman-plugin
    xfce.xfce4-cpufreq-plugin
    xfce.xfce4-cpugraph-plugin
    xfce.xfce4-fsguard-plugin
    xfce.xfce4-genmon-plugin
    xfce.xfce4-netload-plugin
    xfce.xfce4-notifyd
    xfce.xfce4-panel
    xfce.xfce4-panel-profiles
    xfce.xfce4-pulseaudio-plugin
    xfce.xfce4-taskmanager
    xfce.xfce4-screenshooter
    xfce.xfce4-sensors-plugin
    xfce.xfce4-systemload-plugin
    xfce.xfce4-whiskermenu-plugin
    xfce.xfce4-xkb-plugin
    xfce.xfdashboard
    #xfce4-diskperf-plugin
    #xfce4-mount-plugin
    #thunar-extended
    #thunar-custom-actions
    #thunar-shares-plugin
    #gtkhash-thunar
  ];

  security.pam.services.gdm.enableGnomeKeyring = true;

  services = {
    network-manager-applet.enable = true;
    xrdp = {
      enable = true;
      defaultWindowManager = "xfce4-session";
      openFirewall = true;
    };
  };

  programs = {
    dconf.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };
  };

  xserver = {
    enable = true;
    desktopManager.xfce.enable = true;
    excludePackages = with pkgs; [
      xterm
    ];
  };

}
