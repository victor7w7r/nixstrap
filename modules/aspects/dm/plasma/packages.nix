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
            ktexteditor
            kate
          ];
          systemPackages =
            with pkgs.kdePackages;
            [
              filelight
              kamoso
              kbackup
              kcalc
              kcharselect
              kcolorchooser
              kdegraphics-thumbnailers
              kdenetwork-filesharing
              kdf
              kfind
              kget
              kjournald
              kmix
              kompare
              kontrast
              krdc
              ktorrent
              ksystemlog
              partitionmanager
              polkit-qt-1
              qtmultimedia
              qtstyleplugin-kvantum
              sddm-kcm
              sweeper
              inputs.kwin-effects-better-blur-dx.packages.${pkgs.system}.default
              pkgs.application-title-bar
              pkgs.qt5.qtquickcontrols2
              pkgs.qt5.qtgraphicaleffects
              qtquick3d
              qtvirtualkeyboard
              pkgs.heaptrack
              pkgs.ffmpegthumbnailer
              pkgs.kurve
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
            appimage-thumbnailer
            ffmpeg-audio-thumbnailer
            jar-thumbnailer
            kde-control-station
            kde-thumbnailer-apk
            kf6-servicemenus-rootactions
            kmenu
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
