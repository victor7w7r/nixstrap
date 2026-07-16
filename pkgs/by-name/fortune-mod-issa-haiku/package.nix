{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-issa-haiku";
  version = "latest";
  src = inputs.fortune-mod-issa-haiku;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    install -dm755 -- "$out/share/games/fortunes"
    ls .
    install -m644 -- issa-haiku issa-haiku.dat "$out/share/games/fortunes"
  '';
}
