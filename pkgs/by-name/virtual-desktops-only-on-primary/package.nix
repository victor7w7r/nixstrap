{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "virtual-desktops-only-on-primary";
  version = "latest";
  src = inputs.virtual-desktops-only-on-primary;
  installPhase = ''
    mkdir -p $out/share/kwin/scripts/virtual-desktops-only-on-primary
    cp -r * $out/share/kwin/scripts/virtual-desktops-only-on-primary/
  '';
}
