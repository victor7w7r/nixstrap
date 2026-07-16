{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-question-answer-jokes";
  version = "latest";
  src = inputs.fortune-mod-question-answer-jokes;
  dontUnpack = true;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    cp $src question-answer-jokes
    strfile question-answer-jokes
    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- question-answer-jokes question-answer-jokes.dat "$out/share/games/fortunes"
  '';
}
