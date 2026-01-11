{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "aim";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/mihaigalos/aim/releases/download/1.8.6/aim-1.8.6-x86_64-unknown-linux-gnu.tar.gz";
    sha256 = "sha256-8b8T0NS071S6zH6HAqxzptvWbUnPkkUbkaMAIuYX7E8=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/aim
  '';

}
