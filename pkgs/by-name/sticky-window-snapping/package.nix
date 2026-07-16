{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "sticky-window-snapping";
  version = "latest";
  src = inputs.sticky-window-snapping;
  installPhase = ''
    mkdir -p $out/share/kwin/scripts/sticky-window-snapping
    cp -r * $out/share/kwin/scripts/sticky-window-snapping/
  '';
}
