{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "cliwrap";
  version = "latest";
  src = inputs.cliwrap;
  installPhase = "mkdir -p $out/bin && cp $src/cliwrap $out/bin/cliwrap && chmod +x $out/bin/cliwrap";
}
