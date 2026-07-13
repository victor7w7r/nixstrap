{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation (attrs: {
  pname = "app-manager";
  version = "latest";
  src = inputs.app-manager;
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    cp $src/app-manager $out/bin/app-manager
  '';
})
