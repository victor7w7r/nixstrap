{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-protolol";
  version = "master";
  src = inputs.fortune-mod-protolol;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- protolol protolol.dat "$out/share/games/fortunes"
  '';
}
