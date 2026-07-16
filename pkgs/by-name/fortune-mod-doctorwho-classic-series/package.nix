{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-doctorwho-classic-series";
  version = "latest";
  src = inputs.fortune-mod-doctorwho-classic-series;
  dontUnpack = true;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    cp $src doctorwho-classic-series
    strfile doctorwho-classic-series
    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- doctorwho-classic-series doctorwho-classic-series.dat "$out/share/games/fortunes"
  '';
}
