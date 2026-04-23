{
  stdenvNoCC,
  fetchFromGitLab,
  ...
}:
stdenvNoCC.mkDerivation {
  name = "firmware-oneplus-sdm845";
  src = fetchFromGitLab {
    owner = "sdm845-mainline";
    repo = "firmware-oneplus-sdm845";
    rev = "176ca713448c5237a983fb1f158cf3a5c251d775";
    hash = "sha256-ZrBvYO+MY0tlamJngdwhCsI1qpA/2FXoyEys5FAYLj4=";
  };
  installPhase = ''
    cp -a . "$out"
    cd "$out/lib/firmware/postmarketos"
    find . -type f,l | xargs -i bash -c 'mkdir -p "$(dirname "../$1")" && mv "$1" "../$1"' -- {}
    cd "$out/usr"
    find . -type f,l | xargs -i bash -c 'mkdir -p "$(dirname "../$1")" && mv "$1" "../$1"' -- {}
    cd ..
    find "$out"/{usr,lib/firmware/postmarketos} | tac | xargs rmdir
  '';
  dontStrip = true;
}
