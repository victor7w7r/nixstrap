{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-dhammapada";
  version = "latest";
  src = inputs.fortune-mod-dhammapada;
  dontBuild = true;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    install -d $out/share/games/fortunes
    mkdir -p dhammapada-extract

    tar -xJf fortune-dhammapada-1.0.tar.xz -C dhammapada-extract

    install -m 644 dhammapada-extract/fortune-dhammapada-1.0/usr/share/games/fortune/dhammapada $out/share/games/fortunes/dhammapada
    install -m 644 dhammapada-extract/fortune-dhammapada-1.0/usr/share/games/fortune/dhammapada.m $out/share/games/fortunes/dhammapada.m
    install -m 644 dhammapada-extract/fortune-dhammapada-1.0/usr/share/games/fortune/dhammapada.de $out/share/games/fortunes/dhammapada.de
    install -m 644 dhammapada-extract/fortune-dhammapada-1.0/usr/share/games/fortune/dhammapada.pl $out/share/games/fortunes/dhammapada.pl

    strfile $out/share/games/fortunes/dhammapada
    strfile $out/share/games/fortunes/dhammapada.m
    strfile $out/share/games/fortunes/dhammapada.de
    strfile $out/share/games/fortunes/dhammapada.pl
  '';
}
