{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-portal-game";
  version = "latest";
  src = inputs.fortune-mod-portal-game;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    install -dm755 -- "$out/share/games/fortunes"
    mv fortunes/announcer .
    mv fortunes/announcer.dat .
    install -m644 -- announcer announcer.dat "$out/share/games/fortunes"
  '';
}
