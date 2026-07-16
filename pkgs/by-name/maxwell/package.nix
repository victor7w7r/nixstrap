{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "maxwell";
  version = "latest";
  src = inputs.maxwell;
  installPhase = ''
    mkdir -p $out/share/plasma/plasmoids/maxwell
    mv * $out/share/plasma/plasmoids/maxwell/
  '';
}
