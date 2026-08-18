{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "armbian-firmware";
  version = "latest";
  nativeBuildInputs = [ pkgs.findutils ];
  dontBuild = true;
  dontFixup = true;

  src = inputs.armbian-firmware;
  installPhase = ''
    mkdir -p $out/lib/firmware
    cp -a * $out/lib/firmware/
    find . -mindepth 1 -maxdepth 1 ! -name 'rockchip*' ! -name '*uwe5622*' -exec rm -rf {} +
    find -L . -type l -delete
  '';
}
