{
  cache-stdenv,
  inputs,
  pkgs,
}:
cache-stdenv.mkDerivation (attrs: {
  pname = "libfprint-focaltech";
  version = "1.94.9";
  src = pkgs.fetchurl {
    url = "https://web.archive.org/web/20250314121447if_/https://raw.githubusercontent.com/ftfpteams/focaltech-linux-fingerprint-driver/refs/heads/main/Fedora_Redhat/libfprint-2-2_1.94.4%2Btod1_redhat_all_x64_20250219.install";
    sha256 = "sha256-9sPWh6pUNVuPdHA4SBYbYx8G1m3PVf1cjqL9k6tY83g=";
  };
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
