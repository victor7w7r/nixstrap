{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "gfortune";
  version = "latest";
  src = inputs.fortune-mod-g;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    install -dm755 -- "$out/share/games/fortunes"
    ${pkgs.bsdgames}/bin/caesar 13 < gsource > g
    strfile -x g g.dat
    install -m644 -- g g.dat "$out/share/games/fortunes"
  '';
}
