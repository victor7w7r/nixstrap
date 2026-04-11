{
  pkgs,
  inputs,
  username,
  ...
}:
{
  programs.kde-pim.enable = true;

  services = {
    displayManager.defaultSession = "plasma";
    desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
    };
  };
  systemd.services.random-icon = {
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    requires = [ "home-victor7w7r-.ssh.mount" ];
    after = [ "home-victor7w7r-.ssh.mount" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      TARGET_DIR="/nix/persist/etc"
      FILE_NAME="logo.svg"
      [[ -f "$TARGET_DIR/$FILE_NAME" ]] && rm "$TARGET_DIR/$FILE_NAME"
      case $((RANDOM % 5)) in
        0) cp /etc/nixos/nixos/assets/logo-1.svg "$TARGET_DIR/$FILE_NAME" ;;
        1) cp /etc/nixos/nixos/assets/logo-2.svg "$TARGET_DIR/$FILE_NAME" ;;
        2) cp /etc/nixos/nixos/assets/logo-3.svg "$TARGET_DIR/$FILE_NAME" ;;
        3) cp /etc/nixos/nixos/assets/logo-4.svg "$TARGET_DIR/$FILE_NAME" ;;
        4) cp /etc/nixos/nixos/assets/logo-5.svg "$TARGET_DIR/$FILE_NAME" ;;
      esac
    '';
  };
  security.pam.services = {
    sddm.kwallet.enable = true;
    "${username}".kwallet = {
      enable = true;
      package = pkgs.kdePackages.kwallet-pam;
    };
  };
  environment = {
    plasma6.excludePackages = with pkgs; [
      kdePackages.elisa
      kdePackages.khelpcenter
      kdePackages.kate
    ];
    systemPackages = with pkgs; [
      kdePackages.ark
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
      kdePackages.kcmutils
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
      kdePackages.kompare
      kdePackages.konsole
      kdePackages.kontrast
      kdePackages.krdc
      kdePackages.krdp
      kdePackages.ktorrent
      kdePackages.ksystemlog
      kdePackages.kwallet
      kdePackages.kwallet-pam
      kdePackages.okular
      kdePackages.plasma-workspace
      kdePackages.plasma-desktop
      kdePackages.plasma-integration
      kdePackages.partitionmanager
      kdePackages.polkit-qt-1
      kdePackages.polkit-kde-agent-1
      kdePackages.qtmultimedia
      kdePackages.qtstyleplugin-kvantum
      kdePackages.sddm-kcm
      kdePackages.sweeper
      kdePackages.yakuake
      (sddm-astronaut.override {
        themeConfig = {
          # https://github.com/Keyitdev/sddm-astronaut-theme/blob/master/Themes/astronaut.conf
          background = pkgs.fetchurl {
            url = "https://wrothmir.is-a.dev/records/records-on-nixos/record-on-getting-started/images/featured-image.png";
            sha256 = "sha256-7CMuETntiVUCKhUIdJzX+sf3F47GvuX2a61o4xbEzww=";
          };
          ScreenWidth = 1920;
          ScreenHeight = 1080;
          blur = false;
        };
      })
      inputs.kwin-effects-better-blur-dx.packages.${pkgs.system}.default
      libsForQt5.qt5.qtquickcontrols2
      libsForQt5.qt5.qtgraphicaleffects
      kdePackages.qtquick3d
      kdePackages.qtvirtualkeyboard
      #heaptrack
      ffmpegthumbnailer
      graphviz
      icoextract
      icoutils
      kdiff3
      kdiskmark
      krename
      #krita
      krusader
      maliit-keyboard
      onboard
      qpwgraph
      #okteta
      pinentry-qt
      systemdgenie
      ulauncher
    ];
  };
}
