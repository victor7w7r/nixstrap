{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "conway-screensaver";
  version = "latest";
  src = inputs.conway-screensaver;
  buildInputs = with pkgs; [ ncurses ];
  nativeBuildInputs = with pkgs; [
    autoconf
    automake
  ];
  buildFlags = [ "all" ];
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/doc/conway-screensaver
    cp conway-screensaver $out/bin/
    chmod +x $out/bin/conway-screensaver
    cp game_of_life.conf $out/share/doc/conway-screensaver/
  '';

  postPatch = ''
    if [ -f conway-screensaver.c ]; then
      sed -i "s|/usr/share/doc|$out/share/doc|g" conway-screensaver.c
    fi
  '';
}
