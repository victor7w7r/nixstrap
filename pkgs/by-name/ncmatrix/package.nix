{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "ncmatrix";
  version = "latest";
  src = inputs.ncmatrix;
  postPatch = ''
    touch AUTHORS ChangeLog NEWS README
    ln -s ncmatrix.c cmatrix.c
    ln -s ncmatrix.1 cmatrix.1
  '';

  nativeBuildInputs = with pkgs; [
    autoreconfHook
    automake
    autoconf
  ];

  buildInputs = with pkgs; [ ncurses ];
}
