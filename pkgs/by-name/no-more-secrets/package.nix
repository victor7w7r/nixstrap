{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "no-more-secrets";
  version = "master";
  src = inputs.no-more-secrets;

  buildInputs = with pkgs; [ ncurses ];
  nativeBuildInputs = with pkgs; [
    autoconf
    automake
  ];

  makeFlags = [ "prefix=${placeholder "out"}" ];
  buildFlags = [
    "nms-ncurses"
    "sneakers-ncurses"
  ];
}
