{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "customfetch";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/Toni500github/customfetch/releases/download/v2.0.0-beta1/customfetch-linux-v2.0.0-beta1.tar.gz";
    sha256 = "sha256-1UtyOyIimQP3Yzhf1KtW3f9VNhDR7WB6SeLE8bb/HV8=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/customfetch
  '';
}
