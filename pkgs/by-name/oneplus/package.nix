{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  name = "firmware-oneplus-sdm845";
  src = inputs.oneplus;
  installPhase = ''
    cp -a . "$out"
    cd "$out/lib/firmware/postmarketos"
    find . -type f,l | xargs -i bash -c 'mkdir -p "$(dirname "../$1")" && mv "$1" "../$1"' -- {}
    cd "$out/usr"
    find . -type f,l | xargs -i bash -c 'mkdir -p "$(dirname "../$1")" && mv "$1" "../$1"' -- {}
    cd ..
    find "$out"/{usr,lib/firmware/postmarketos} | tac | xargs rmdir
  '';
}
