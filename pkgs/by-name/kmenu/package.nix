{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "kMenu";
  version = "latest";
  src = inputs.kMenu;
  installPhase = ''
    mkdir -p $out/share/plasma/plasmoids
    mv package $out/share/plasma/plasmoids/org.51n7.kMenu
  '';
}
