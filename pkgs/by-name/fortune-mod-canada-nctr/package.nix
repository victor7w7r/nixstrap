{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-canada-nctr";
  version = "latest";
  src = inputs.fortune-mod-canada-nctr;
  dontBuild = true;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    strfile nctr
    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- nctr nctr.dat "$out/share/games/fortunes"
  '';
}
