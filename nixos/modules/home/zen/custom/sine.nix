{ pkgs, ... }:
pkgs.stdenv.mkDerivation rec {
  pname = "sine";
  version = "1.0";

  src = pkgs.fetchFromGitHub {
    owner = "CosmoCreeper";
    repo = "Sine";
    rev = "cosine";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };

  buildPhase = ''
    mkdir -p $out/JS
    unzip ${src}/deployment/engine.zip -d $out/JS/
  '';
}
