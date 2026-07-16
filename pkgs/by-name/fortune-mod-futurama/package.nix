{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-futurama";
  version = "latest";
  src = inputs.fortune-mod-futurama;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    strfile futurama futurama.dat
    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- futurama futurama.dat "$out/share/games/fortunes"
  '';
}
