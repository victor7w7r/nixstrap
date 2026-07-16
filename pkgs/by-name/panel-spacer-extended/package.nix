{ inputs, pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "kde-panel-spacer-extended-widget";
  version = "latest";
  src = inputs.panel-spacer-extended;
  propagatedUserEnvPkgs = with pkgs; [ glib ];
  dontBuild = true;
  dontWrapQtApps = true;
  installPhase = ''
    mkdir -p $out/share/plasma/plasmoids/luisbocanegra.panelspacer.extended
    cp -r $src/package/* $out/share/plasma/plasmoids/luisbocanegra.panelspacer.extended
  '';
  passthru.updateScript = pkgs.nix-update-script { };
}
