{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-husse";
  version = "latest";
  dontUnpack = true;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    cp ${inputs.husse-funny} husse-funny
    cp ${inputs.husse-helping} husse-helping
    cp ${inputs.husse-moderating} husse-moderating
    cp ${inputs.husse-self} husse-self

    strfile husse-funny
    strfile husse-helping
    strfile husse-moderating
    strfile husse-self

    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- husse-funny husse-funny.dat "$out/share/games/fortunes"
    install -m644 -- husse-helping husse-helping.dat "$out/share/games/fortunes"
    install -m644 -- husse-moderating husse-moderating.dat "$out/share/games/fortunes"
    install -m644 -- husse-self husse-self.dat "$out/share/games/fortunes"
  '';
}
