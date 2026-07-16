{ inputs, pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "kde-wallpaper-effects-widget";
  version = "version";
  src = inputs.wallpaper-effects;
  dontBuild = true;
  dontWrapQtApps = true;
  installPhase = ''
    mkdir -p $out/share/plasma/plasmoids/luisbocanegra.desktop.wallpaper.effects
    cp -r $src/package/* $out/share/plasma/plasmoids/luisbocanegra.desktop.wallpaper.effects
  '';
  passthru.updateScript = pkgs.nix-update-script { };
}
