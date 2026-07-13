{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "btrfsd";
  version = "main";
  src = inputs.btrfsd;

  nativeBuildInputs = with pkgs; [
    meson
    ninja
    pkg-config
    libxslt
    docbook_xsl
  ];

  buildInputs = with pkgs; [
    util-linux
    json-glib
    glib
    systemd
  ];

  preConfigure = ''
    if [ -f data/meson.build ]; then
      sed -i "s|systemd_unit_dir = .*|systemd_unit_dir = '$out/lib/systemd/system'|g" data/meson.build
    fi
  '';

  pkgconfigSystemdSystemUnitDir = "${placeholder "out"}/lib/systemd/system";
  mesonBuildType = "debugoptimized";
}
