{
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation rec {
  pname = "kde-wallpaper-effects-widget";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "plasma-wallpaper-effects";
    rev = "refs/tags/v${version}";
    hash = "sha256-fhVxhJESbCkm0WItBCEN83RvSwzjYGgCVyX/3j51uhA=";
  };

  dontBuild = true;
  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids/luisbocanegra.desktop.wallpaper.effects
    cp -r $src/package/* $out/share/plasma/plasmoids/luisbocanegra.desktop.wallpaper.effects
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };
}
