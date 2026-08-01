{
  cache-stdenv,
  inputs,
  pkgs,
}:
cache-stdenv.mkDerivation (attrs: {
  pname = "libfprint-focaltech";
  version = "1.94.9";
  src = inputs.focaltech;
  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    copyPkgconfigItems
    cpio
    pkg-config
    rpm
  ];

  buildInputs = with pkgs; [
    cairo
    glib
    gusb
    libfprint
    libgudev
    nss
    pixman
    stdenv.cc.cc
  ];

  unpackPhase = ''
    runHook preUnpack
    echo "Extracting embedded tar.gz using sed"

    sed '1,/^main \$@/d' $src > libfprint.tar.gz

    mkdir extracted
    tar -xzf libfprint.tar.gz -C .
  '';

  pkgconfigItems = with pkgs; [
    (makePkgconfigItem rec {
      name = "libfprint-2";
      version = attrs.version;
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

  installPhase =
    let
      libso = "libfprint-2.so.2.0.0";
    in
    ''
      runHook preInstall

      install -Dm444 usr/lib64/${libso} -t $out/lib

      ln -s -T $out/lib/${libso} $out/lib/libfprint-2.so
      ln -s -T $out/lib/${libso} $out/lib/libfprint-2.so.2

      cp -r ${pkgs.libfprint}/lib/girepository-1.0 $out/lib
      cp -r ${pkgs.libfprint}/include $out

      runHook postInstall
    '';
})
