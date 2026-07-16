{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-billwurtz";
  version = "latest";
  src = inputs.fortune-mod-billwurtz;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- billwurtz billwurtz.dat "$out/share/games/fortunes"
  '';
}
