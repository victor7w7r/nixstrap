{ cache-stdenv, pkgs }:
cache-stdenv.mkDerivation (attrs: {
  pname = "breezy-desktop";
  version = "2.11.8";

  src = pkgs.fetchFromGitHub {
    owner = "wheaney";
    repo = "breezy-desktop";
    rev = "v${attrs.version}";
    hash = "sha256-rRDdvFhoI3nE9zET2Whr/BSQ3J7JQzpv7/AAdvfW4wY=";
    fetchSubmodules = true;
  };

  sourceRoot = "breezy-desktop/ui";

  unpackPhase = ''
    cp -r $src $TMPDIR/breezy-desktop
    chmod -R u+w $TMPDIR/breezy-desktop
    cd $TMPDIR/breezy-desktop/ui
    sourceRoot=$(pwd)
  '';

  nativeBuildInputs = with pkgs; [
    meson
    ninja
    pkg-config
    gettext
    glib
    gtk4
    desktop-file-utils
    gobject-introspection
    wrapGAppsHook4
    appstream
  ];

  buildInputs = with pkgs; [
    gtk4
    libadwaita
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    (python3.withPackages (
      ps: with ps; [
        pygobject3
        pydbus
      ]
    ))
  ];

  postPatch = ''
    substituteInPlace src/breezydesktop.in \
      --replace-fail "appdir = os.getenv('APPDIR', xdg_data_home)" \
                     "appdir = os.getenv('APPDIR', '$out/share')"
    substituteInPlace src/virtualdisplay.in \
      --replace-fail "appdir = os.getenv('APPDIR', xdg_data_home)" \
                     "appdir = os.getenv('APPDIR', '$out/share')" || true

    substituteInPlace src/meson.build \
      --replace-fail "'virtualdisplay.py'," "'virtualdisplay.py', 'virtualdisplayrow.py',"
  '';

  mesonFlags = [ ];
})
