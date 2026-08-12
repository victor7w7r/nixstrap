{
  cache-stdenv,
  pkgs,
}:
cache-stdenv.mkDerivation {
  pname = "gtkhash-thunar";
  version = "latest";
  src = pkgs.fetchurl {
    url = "https://github.com/tristanheaven/gtkhash/releases/download/v1.5/gtkhash-1.5.tar.xz";
    sha256 = "sha256-cQKhkuyj6C7WeoJSpoUEQOUMHb6nxjZL2hVOyA+P8AU=";
  };

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
