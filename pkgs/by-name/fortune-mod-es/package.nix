{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortunes-es";
  version = "latest";
  src = inputs.fortunes-es;
  nativeBuildInputs = with pkgs; [
    fortune
    recode
  ];

  # dontBuild = true;
  postPatch = "find . -name Makefile -exec sed -i 's|/usr/bin/strfile|strfile|g' {} +''";
  installPhase = ''
    install -d "$out/share/games/fortunes"
    make prefix="$out" \
      COOKIEDIR="$out/share/games/fortunes" \
      OCOOKIEDIR="$out/share/games/fortunes/off" \
      WCOOKIEDIR="$out/share/games/fortunes/html" \
      install-utf8

    cd "$out/share/games/fortunes"
    rm -f *.u8 off/*.u8 2>/dev/null || true

    shopt -s nullglob
    for f in *.fortunes* off/*.fortunes*; do
      mv "$f" "''${f/.fortunes}"
    done
    shopt -u nullglob
  '';
}
