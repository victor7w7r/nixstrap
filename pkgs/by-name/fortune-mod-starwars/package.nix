{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-starwars";
  version = "latest";
  src = inputs.fortune-mod-starwars;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- starwars* "$out/share/games/fortunes"
  '';
}
