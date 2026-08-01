{
  cache-stdenv,
  inputs,
  pkgs,
}:
cache-stdenv.mkDerivation (attrs: {
  pname = "sandscreen";
  version = "latest";
  src = inputs.sandscreen;
  buildInputs = with pkgs; [ ncurses ];
  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp ${attrs.pname} $out/bin/ || cp bin/${attrs.pname} $out/bin/ || cp ./* $out/bin/ 2>/dev/null || true
  '';
})
