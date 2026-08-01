{
  cache-stdenv,
  inputs,
  pkgs,
}:
cache-stdenv.mkDerivation {
  pname = "q6voiced";
  version = "unstable-2022-07-08";
  src = inputs.q6voiced;
  buildInputs = with pkgs; [
    dbus
    tinyalsa
  ];
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildPhase = "cc $(pkg-config --cflags --libs dbus-1) -ltinyalsa -o q6voiced q6voiced.c";
  installPhase = ''install -m555 -Dt "$out/bin" q6voiced'';
}
