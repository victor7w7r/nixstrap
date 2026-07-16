{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "gtkhash-thunar";
  version = "latest";
  src = inputs.gtkhash-thunar;

  nativeBuildInputs = with pkgs; [
    meson
    ninja
    pkg-config
    intltool
    appstream-glib
    desktop-file-utils
    wrapGAppsHook3
  ];

  buildInputs = with pkgs; [
    gtk3
    dconf
    libb2
    libgcrypt
    nettle
    librsvg
    xfce.thunar
  ];

  mesonFlags = [
    "-Dglib-checksums=true"
    "-Dlinux-crypto=true"
    "-Dnettle=true"
    "-Dbuild-caja=false"
    "-Dbuild-nautilus=false"
    "-Dbuild-nemo=false"
    "-Dbuild-thunar=true"
  ];

  doCheck = false;
}
