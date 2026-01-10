{
  pkgs,
  inputs,
  system,
  ...
}:
{
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
  };

  services = {
    displayManager.defaultSession = "plasma";
    desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
    };
  };

  environment.systemPackages = with pkgs; [
    inputs.nixos-conf-editor.packages.${system}.nixos-conf-editor
    kdePackages.ark
    kdePackages.audiotube
    kdePackages.baloo-widgets
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.ffmpegthumbs
    kdePackages.filelight
    kdePackages.gwenview
    kdePackages.isoimagewriter
    kdePackages.kamoso
    kdePackages.kbackup
    kdePackages.kcalc
    kdePackages.kcachegrind
    kdePackages.kcharselect
    kdePackages.kcolorchooser
    kdePackages.kcron
    kdePackages.kdegraphics-thumbnailers
    kdePackages.kdenetwork-filesharing
    kdePackages.kdf
    kdePackages.kfind
    kdePackages.kget
    kdePackages.kgpg
    kdePackages.kjournald
    kdePackages.kmix
    kdePackages.koko
    kdePackages.kolourpaint
    kdePackages.kompare
    kdePackages.konsole
    kdePackages.kontrast
    kdePackages.krdc
    kdePackages.krdp
    kdePackages.ktorrent
    kdePackages.ksystemlog
    kdePackages.merkuro
    kdePackages.okular
    kdePackages.plasma-workspace
    kdePackages.plasma-desktop
    kdePackages.partitionmanager
    kdePackages.qtmultimedia
    kdePackages.qtstyleplugin-kvantum
    kdePackages.sddm-kcm
    kdePackages.sweeper
    kdePackages.yakuake
    heaptrack
    ffmpegthumbnailer
    graphviz
    icoextract
    icoutils
    iio-sensor-proxy
    kdiff3
    kdiskmark
    krename
    krita
    krusader
    maliit-keyboard
    onboard
    qpwgraph
    okteta
    systemdgenie
    ulauncher
  ];
}
