{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-calvin";
  version = "latest";
  src = inputs.fortune-mod-calvin;
  dontUnpack = true;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    cp $src calvin
    strfile calvin
    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- calvin calvin.dat "$out/share/games/fortunes"
  '';
}
