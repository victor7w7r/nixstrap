{
  stdenv,
  fetchFromGitHub,
  gitUpdater,
}:
stdenv.mkDerivation rec {
  pname = "layan-kde";
  version = "2025-02-13";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "2025-02-13";
    hash = "sha256-Wh8tZcQEdTTlgtBf4ovapojHcpPBZDDkWOclmxZv9zA=";
  };

  postPatch = ''
    patchShebangs install.sh
    substituteInPlace install.sh \
      --replace 'if [ "$UID" -eq "$ROOT_UID" ]; then' 'if [ false ]; then'
    substituteInPlace install.sh \
      --replace '$HOME/.local' $out \
      --replace '$HOME/.config' $out/share
  '';

  installPhase = ''
    mkdir -p $out/share
    runHook preInstall
    ./install.sh
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };
}
