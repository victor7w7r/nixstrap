{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "plasma-wallpaper-effects";
  version = "v2.0.0";

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = pname;
    rev = "HEAD";
    hash = "sha256-Wh8tZcQEdTTlgtBf4ovapojHcpPBZDDkWOclmxZv9zA=";
  };

  postPatch = ''
    patchShebangs install.sh
    substituteInPlace install.sh --replace '$HOME/.local' $out
  '';

  installPhase = ''
    runHook preInstall
    ./install.sh
    runHook postInstall
  '';

  meta = with lib; {
    description = "KDE Plasma Widget to enable Active Blur and other effects for all Wallpaper Plugins";
    homepage = "https://github.com/luisbocanegra/plasma-wallpaper-effects";
    license = licenses.gpl3Only;
    platforms = platforms.all;
  };
}
