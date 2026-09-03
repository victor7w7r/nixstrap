{ cache-stdenv, pkgs }:
cache-stdenv.mkDerivation (attrs: {
  pname = "breezy-desktop";
  version = "2.11.8";

  src = pkgs.fetchFromGitHub {
    owner = "wheaney";
    repo = "breezy-desktop";
    rev = "v${attrs.version}";
    hash = "sha256-rRDdvFhoI3nE9zET2Whr/BSQ3J7JQzpv7/UUdvfW4wY=";
    fetchSubmodules = true;
  };

  sourceRoot = ".";

  unpackPhase = ''
    cp -r $src $TMPDIR/breezy-desktop
    chmod -R u+w $TMPDIR/breezy-desktop
    cd $TMPDIR/breezy-desktop/kwin
  '';

  nativeBuildInputs = with pkgs; [
    cmake
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = with pkgs.kdePackages; [
    kconfig
    kconfigwidgets
    kcoreaddons
    kglobalaccel
    ki18n
    kcmutils
    kwindowsystem
    kxmlgui
    kwin
    qtbase
    qtdeclarative
    qt3d
    qtquick3d
    libepoxy
  ];

  postPatch = ''
        echo "${attrs.version}" > ../VERSION
        echo "${attrs.version}" > VERSION

        cp ../ui/modules/PyXRLinuxDriverIPC/xrdriveripc.py src/xrdriveripc/xrdriveripc.py
        cp ../ui/data/icons/hicolor/scalable/apps/com.xronlinux.BreezyDesktop.svg src/kcm/com.xronlinux.BreezyDesktop.svg

        substituteInPlace cmake/info.cmake --replace-fail '/usr/include/kwin/effect/effect.h' '${pkgs.kdePackages.kwin.dev}/include/kwin/effect/effect.h'

        substituteInPlace CMakeLists.txt \
            --replace-fail 'execute_process(
        COMMAND ''${QT6_QMAKE_EXECUTABLE} -query QT_INSTALL_QML
        OUTPUT_VARIABLE QT6_QML_DIR
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )' 'set(QT6_QML_DIR "${pkgs.kdePackages.qtquick3d}/lib/qt-6/qml")'

        substituteInPlace src/CMakeLists.txt --replace-fail 'target_include_directories(breezy_desktop PRIVATE /usr/include/kwin)' \
          'target_include_directories(breezy_desktop PRIVATE ${pkgs.kdePackages.kwin.dev}/include/kwin)'
  '';

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];
})
