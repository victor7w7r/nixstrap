{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "neo-cowsay";
  version = "latest";
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin $out/cowsay
    cp -r ${
      if stdenvNoCC.hostPlatform.isAarch64 then inputs.neo-cowsay-arm64 else inputs.neo-cowsay-amd64
    }/* $out/cowsay/
    mv $out/cowsay/cowsay $out/bin/ && mv $out/cowsay/cowthink $out/bin/
    chmod +x $out/bin/cowsay && chmod +x $out/bin/cowthink
  '';
}
