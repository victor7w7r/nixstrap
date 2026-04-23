{
  lib,
  pkgs,
  kernel,
  kernelData,
  ...
}:
let
  majorMinor = lib.versions.majorMinor kernelData.sdm845.version;
  fetch = (pkgs.callPackage ../fetch.nix { inherit kernelData majorMinor; });
  localVer = "-v7w7r-sdm845";
  config = (import ./config.nix);
  patches = [
    # "${fetch.patches}/${majorMinor}/misc/reflex-governor.patch"
    # "${fetch.patches}/${majorMinor}/misc/nap-governor.patch"
  ];
in
pkgs.stdenv.mkDerivation {
  inherit patches;
  src = fetch.sdm845;
  name = "linux-${majorMinor}${localVer}-config";
  stdenv = pkgs.gcc14Stdenv.override {
    stdenv = pkgs.ccacheStdenv;
  };

  nativeBuildInputs = kernel.nativeBuildInputs ++ kernel.buildInputs;
  installPhase = "cp .config $out";
  buildPhase = ''
    export ARCH=arm64

    cp arch/arm64/configs/sdm845.config .config
    patchShebangs scripts/config
    scripts/config ${lib.concatStringsSep " " config}
    scripts/config --undefine CONFIG_LOCALVERSION
    scripts/config --set-str CONFIG_LOCALVERSION "${localVer}"
    make $makeFlags olddefconfig
  '';

  passthru = {
    inherit localVer patches;
    version = kernelData.sdm845.version;
  };
}
