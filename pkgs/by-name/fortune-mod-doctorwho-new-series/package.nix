{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-doctorwho-new-series";
  version = "latest";
  src = inputs.fortune-mod-doctorwho-new-series;
  dontUnpack = true;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    cp $src doctorwho-new-series
    strfile doctorwho-new-series
    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- doctorwho-new-series doctorwho-new-series.dat "$out/share/games/fortunes"
  '';
}
