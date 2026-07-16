{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-limetricks";
  version = "latest";
  src = inputs.fortune-mod-limetricks;
  dontUnpack = true;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    cp $src limericks
    strfile limericks
    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- limericks limericks.dat "$out/share/games/fortunes"
  '';
}
