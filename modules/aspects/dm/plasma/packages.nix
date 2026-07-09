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
              pkgs.krename
              pkgs.kdePackages.isoimagewriter
              pkgs.ulauncher
            ]);
        };
      };

    provides.to-users.homeManager =
      { pkgs, self', ... }:
      {
        home.packages =
          with pkgs;
          with self'.packages;
          [
            application-title-bar
            appimage-thumbnailer
            ffmpeg-audio-thumbnailer
            jar-thumbnailer
            kde-control-station
            kde-thumbnailer-apk
            kf6-servicemenus-rootactions
            kmenu
            kurve
            kzones
            layan
            maxwell
            plasma-drawer
            panel-spacer-extended
            sticky-window-snapping
            virtual-desktops-only-on-primary
            wallpaper-effects
          ];
      };
  };
}
