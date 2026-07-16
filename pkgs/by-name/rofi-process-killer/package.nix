{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "rofi-process-killer";
  version = "latest";
  src = inputs.rofi-process-killer;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp -r $src/* $out/bin/
    chmod +x $out/bin/rofi-process-killer.sh
  '';
}
