{ inputs, pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "audiosource";
  version = "latest";
  src = pkgs.fetchurl {
    url = "https://github.com/gdzx/audiosource/releases/download/v1.5/audiosource";
    sha256 = "sha256-9mk5SgkmaO6qcv/49WvDwvr0BsPnddEeQX0GWgFNDEk=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin && cp $src $out/bin/audiosource
    chmod +x $out/bin/audiosource
  '';
}
