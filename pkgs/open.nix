{
  stdenv,
  fetchurl,
  lib,
  ...
}:

let
  open = stdenv.mkDerivation rec {
    pname = "open";
    version = "0.0.3";

    srcs = {
      openScript = fetchurl {
        url = "https://github.com/witt-bit/pc-guide/releases/download/v${version}/open.sh";
        sha256 = "d9d0ae0225817945f4c8cf8a37741ce884226c6b8f66066a557f122c4d3c2305";
      };
    };

    dontStrip = true;
    installPhase = ''
      mkdir -p $out/usr/share/open
      mkdir -p $out/usr/bin
      mkdir -p $out/usr/share/licenses/${pname}
      install -m755 ${srcs.openScript} $out/usr/share/open/open.sh
      ln -s ../share/open/open.sh $out/usr/bin/open
      install -m644 ${srcs.licenseFile} $out/usr/share/licenses/${pname}/LICENSE
    '';

    meta = {
      description = "Use the open command to open a folder in a GUI window";
      homepage = "https://github.com/witt-bit/pc-guide";
      license = lib.licenses.asl20;
      platforms = lib.platforms.all;
    };
  };
in
{
  environment.systemPackages = [ open ];
}
