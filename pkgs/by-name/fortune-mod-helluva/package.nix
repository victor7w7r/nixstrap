{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-helluva";
  version = "latest";
  dontUnpack = true;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    cp ${inputs.helluva-beelzebub} beelzebub
    cp ${inputs.helluva-blitz} blitz
    cp ${inputs.helluva-loona} loona
    cp ${inputs.helluva-millie} millie
    cp ${inputs.helluva-moxxie} moxxie

    strfile beelzebub
    strfile blitz
    strfile loona
    strfile millie
    strfile moxxie

    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- beelzebub beelzebub.dat "$out/share/games/fortunes"
    install -m644 -- blitz blitz.dat "$out/share/games/fortunes"
    install -m644 -- loona loona.dat "$out/share/games/fortunes"
    install -m644 -- millie millie.dat "$out/share/games/fortunes"
    install -m644 -- moxxie moxxie.dat "$out/share/games/fortunes"
  '';
}
