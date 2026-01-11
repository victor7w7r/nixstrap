{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "lyricstify";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/lyricstify/lyricstify/releases/download/v1.1.2/lyricstify-linux";
    sha256 = "sha256-VukOghkBZ3OKZUYfnoFeRcM6DdGVZaKWYqbwO/d95sw=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    unzip $src -d $out/bin/
    chmod +x $out/bin/lyricstify
  '';
}
