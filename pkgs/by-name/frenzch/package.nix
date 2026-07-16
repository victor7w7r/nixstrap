{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "frenzch.sh";
  version = "latest";
  src = inputs.frenzch;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp $src/frenzch.sh $out/bin/frenzch
    cp $src/info.sh $out/bin/info.sh
    cp $src/bash_jesus.sh $out/bin/bash_jesus.sh
    chmod +x $out/bin/frenzch
    chmod +x $out/bin/info.sh
    chmod +x $out/bin/bash_jesus.sh
  '';
}
