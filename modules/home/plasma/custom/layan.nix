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

  installPhase = ''
    mkdir -p $out/share
    runHook preInstall

    AURORAE_DIR="$out/share/aurorae/themes"
    SCHEMES_DIR="$out/share/color-schemes"
    PLASMA_DIR="$out/share/plasma/desktoptheme"
    LAYOUT_DIR="$out/share/plasma/layout-templates"
    LOOKFEEL_DIR="$out/share/plasma/look-and-feel"
    KVANTUM_DIR="$out/share/Kvantum"
    WALLPAPER_DIR="$out/share/wallpapers"

    mkdir -p $AURORAE_DIR $SCHEMES_DIR $PLASMA_DIR $LOOKFEEL_DIR $KVANTUM_DIR $WALLPAPER_DIR

    mv ./aurorae/themes/Layan* $AURORAE_DIR/
    mv ./Kvantum/Layan* $KVANTUM_DIR/
    mv ./plasma/desktoptheme/common $PLASMA_DIR/Layan
    mv ./plasma/desktoptheme/Layan/* $PLASMA_DIR/Layan/
    mv ./color-schemes/LayanLight.colors $SCHEMES_DIR/
    mv ./color-schemes/LayanLight.colors $PLASMA_DIR/Layan/colors/
    mv ./plasma/look-and-feel/com.github.vinceliuice.Layan $LOOKFEEL_DIR/
    mv ./wallpaper/Layan $WALLPAPER_DIR/

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };
}
