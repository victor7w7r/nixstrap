{ pkgs }:
pkgs.stdenv.mkDerivation (attrs: {
  pname = "xfce4-mount-plugin";
  version = "1.2.0";
  src = pkgs.fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "panel-plugins";
    repo = "xfce4-mount-plugin";
    rev = "refs/tags/${attrs.pname}-${attrs.version}";
    sha256 = "sha256-9jgmrSanLs2EtnCOFaXu007O9n9VqmR+E1umGfJQ+T0=";
  };

  nativeBuildInputs = with pkgs; [
    meson
    ninja
    pkg-config
    intltool
    wrapGAppsHook3
  ];

  buildInputs = with pkgs; [
    xfce4-panel
    libxfce4ui
    libxfce4util
    glib
  ];
})
