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
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 $src $out/bin/lyricstify
    runHook postInstall
  '';
}
