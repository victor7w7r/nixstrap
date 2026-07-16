{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-anarchism";
  version = "latest";
  src = inputs.fortune-mod-anarchism;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- anarchism anarchism.dat "$out/share/games/fortunes"
  '';
}
