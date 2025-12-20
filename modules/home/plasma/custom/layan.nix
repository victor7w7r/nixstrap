{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
}:
stdenv.mkDerivation rec {
  pname = "layan-kde";
  version = "2025-02-13";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "7ab7cd7461dae8d8d6228d3919efbceea5f4272c";
    hash = "sha256-Wh8tZcQEdTTlgtBf4ovapojHcpPBZDDkWOclmxZv9zA=";
  };

  postPatch = ''
    patchShebangs install.sh
    substituteInPlace install.sh \
      --replace 'if [ "$UID" -eq "$ROOT_UID" ]; then' 'if [ false ]; then'
    substituteInPlace install.sh \
      --replace '$HOME/.local' $out \
      --replace '$HOME/.config' $out/share

    if [ -d sddm ]; then
      find sddm -name "*.qml" -exec sed -i "s|/usr|$out|g" {} +
    fi
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/sddm/themes
    ./install.sh
    if [ -d sddm ]; then
        mkdir -p $out/share/sddm/themes
        cp -ra sddm/Layan* $out/share/sddm/themes
    fi
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Flat Design theme for KDE Plasma desktop";
    homepage = "https://github.com/vinceliuice/Layan-kde";
    license = licenses.gpl3Only;
    platforms = platforms.all;
  };
}
