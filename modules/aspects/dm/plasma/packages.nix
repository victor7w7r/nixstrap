{ inputs, ... }:
{
  flake-file.inputs.kwin-effects-better-blur-dx = {
    url = "github:xarblu/kwin-effects-better-blur-dx";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.plasma.default-packages = {
    nixos =
      {
        hasVisualKeyboard,
        lib,
        pkgs,
        ...
      }:
      {
        environment = {
          plasma6.excludePackages = with pkgs.kdePackages; [
            elisa
            khelpcenter
            kate
          ];
          systemPackages =
            with pkgs.kdePackages;
            [
              ark
              baloo-widgets
              dolphin
              dolphin-plugins
              ffmpegthumbs
              filelight
              gwenview
              kamoso
              kbackup
              kcalc
              kcachegrind
              kcharselect
              kcmutils
              kcolorchooser
              kcron
              kdegraphics-thumbnailers
              kdenetwork-filesharing
              kdf
              kfind
              kget
              kgpg
              kjournald
              kmix
              koko
              kompare
              konsole
              kontrast
              krdc
              krdp
              ktorrent
              ksystemlog
              kwallet
              kwallet-pam
              okular
              plasma-workspace
              plasma-desktop
              plasma-integration
              partitionmanager
              polkit-qt-1
              polkit-kde-agent-1
              qtmultimedia
              qtstyleplugin-kvantum
              sddm-kcm
              sweeper
              yakuake
              inputs.kwin-effects-better-blur-dx.packages.${pkgs.system}.default
              pkgs.qt5.qtquickcontrols2
              pkgs.qt5.qtgraphicaleffects
              qtquick3d
              qtvirtualkeyboard
              pkgs.heaptrack
              pkgs.ffmpegthumbnailer
              pkgs.graphviz
              pkgs.icoextract
              pkgs.icoutils
              pkgs.kdiff3
              pkgs.kdiskmark
              pkgs.krita
              pkgs.krusader
              pkgs.maliit-keyboard
              pkgs.onboard
              pkgs.qpwgraph
              pkgs.okteta
              pkgs.pinentry-qt
              pkgs.systemdgenie
            ]
            ++ (lib.optionals hasVisualKeyboard [
              krename
              isoimagewriter
              ulauncher
            ]);
        };
      };

    provides.to-users.homeManager =
      { pkgs, self', ... }:
      {
        home.packages = with pkgs; [
          application-title-bar
          self'.packages.appimage-thumbnailer
          self'.packages.ffmpeg-audio-thumbnailer
          self'.packages.jar-thumbnailer
          self'.packages.kde-control-station
          self'.packages.kde-thumbnailer-apk
          self'.packages.kf6-servicemenus-rootactions
          self'.packages.kmenu
          kurve
          self'.packages.kzones
          self'.packages.layan
          self'.packages.maxwell
          self'.packages.plasma-drawer
          self'.packages.panel-spacer-extended
          self'.packages.sticky-window-snapping
          self'.packages.virtual-desktops-only-on-primary
          self'.packages.wallpaper-effects
        ];
      };
  };
}
