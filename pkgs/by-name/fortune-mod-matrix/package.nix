{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-matrix";
  version = "latest";
  src = inputs.fortune-mod-matrix;
  dontUnpack = true;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    cp $src matrix
    strfile matrix
    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- matrix matrix.dat "$out/share/games/fortunes"
  '';
}
