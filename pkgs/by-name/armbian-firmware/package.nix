{ inputs, pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "armbian-firmware";
  version = "latest";
  nativeBuildInputs = [
    pkgs.findutils
    pkgs.zstd
  ];
  dontBuild = true;

  src = inputs.armbian-firmware;

  installPhase = ''
    mkdir -p $out/lib/firmware
    cp -a * $out/lib/firmware/

    cd $out/lib/firmware

    find . -mindepth 1 -maxdepth 1 ! -name 'arm*' ! -name 'rockchip*' ! -name '*uwe5622*' -exec rm -rf {} +
    find -L . -type l -delete
  '';
}
