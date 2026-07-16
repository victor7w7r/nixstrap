{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-darkknight";
  version = "latest";
  src = inputs.fortune-mod-darkknight;
  dontUnpack = true;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    cp $src darkknight
    strfile darkknight
    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- darkknight darkknight.dat "$out/share/games/fortunes"
  '';
}
