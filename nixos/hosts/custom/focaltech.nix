{
  stdenv,
  fetchurl,
  rpm,
  cpio,
  glib,
  gusb,
  pixman,
  libgudev,
  nss,
  libfprint,
  cairo,
  pkg-config,
  autoPatchelfHook,
  makePkgconfigItem,
  copyPkgconfigItems,
}:
let
  libso = "libfprint-2.so.2.0.0";
in
stdenv.mkDerivation rec {
  pname = "libfprint-focaltech-2808-a658-alt";
  version = "1.94.4";

  src = fetchurl {
    url = "https://github.com/Varrkan82/RTS5811-FT9366-fingerprint-linux-driver-with-VID-2808-and-PID-a658/raw/b040ccd953c27e26c1285c456b4264e70b36bc3f/libfprint-2-2-1.94.4+tod1-FT9366_20240627.x86_64.rpm";
    hash = "sha256-MRWHwBievAfTfQqjs1WGKBnht9cIDj9aYiT3YJ0/CUM=";
  };

  nativeBuildInputs = [
    rpm
    cpio
    pkg-config
    autoPatchelfHook
    copyPkgconfigItems
  ];

  buildInputs = [
    stdenv.cc.cc
    glib
    gusb
    pixman
    nss
    libgudev
    libfprint
    cairo
  ];

  unpackPhase = ''
    runHook preUnpack

    rpm2cpio $src | cpio -idmv

    runHook postUnpack
  '';

  pkgconfigItems = [
    (makePkgconfigItem rec {
      name = "libfprint-2";
      inherit version;
      cflags = [ "-I${variables.includedir}/libfprint-2" ];
      libs = [
        "-L${variables.libdir}"
        "-lfprint-2"
      ];
      variables = rec {
        prefix = "${placeholder "out"}";
        includedir = "${prefix}/include";
        libdir = "${prefix}/lib";
      };
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm444 usr/lib64/${libso} -t $out/lib

    ln -s -T $out/lib/${libso} $out/lib/libfprint-2.so
    ln -s -T $out/lib/${libso} $out/lib/libfprint-2.so.2

    cp -r ${libfprint}/lib/girepository-1.0 $out/lib
    cp -r ${libfprint}/include $out

    runHook postInstall
  '';
}
