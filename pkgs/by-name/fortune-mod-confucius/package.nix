{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-confucius";
  version = "latest";
  src = inputs.fortune-mod-confucius;
  dontUnpack = true;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    cp $src confucius
    strfile confucius
    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- confucius confucius.dat "$out/share/games/fortunes"
  '';
}
