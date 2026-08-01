{
  cache-stdenv,
  inputs,
  pkgs,
}:
cache-stdenv.mkDerivation {
  pname = "neo";
  version = "latest";
  src = inputs.neo;
  buildInputs = with pkgs; [ ncurses ];
  nativeBuildInputs = with pkgs; [
    autoconf
    automake
  ];
  preConfigure = "./autogen.sh";
  makeFlags = [ "PREFIX=$(out)" ];
}
