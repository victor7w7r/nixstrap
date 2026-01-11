{
  pkgs,
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "carbonyl";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/fathyb/carbonyl/releases/download/v0.0.3/carbonyl.linux-amd64.zip";
    sha256 = "sha256-RqkC6im7Mvdz+07jQUI3BbkjRagQQiuN+T6upqHsetI=";
  };

  nativeBuildInputs = with pkgs; [ unzip ];
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    unzip $src -d $out/bin/
    chmod +x $out/bin/carbonyl
  '';

}
