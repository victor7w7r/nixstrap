{
  lib,
  pkgs,
  kernelData,
  ...
}:
let
  majorMinor = lib.versions.majorMinor kernelData.sdm845.version;
  fetch = (pkgs.callPackage ../fetch.nix { inherit kernelData majorMinor; });
  localVer = "-v7w7r-sdm845";
  config = (import ./config.nix);
  patches = [
    "${fetch.patches}/${majorMinor}/misc/reflex-governor.patch"
    "${fetch.patches}/${majorMinor}/misc/nap-governor.patch"
  ];
in
pkgs.stdenv.mkDerivation {
  inherit patches;
  src = fetch.sdm845;
  name = "linux-${majorMinor}${localVer}-config";
  stdenv = pkgs.ccacheStdenv;
  nativeBuildInputs = with pkgs; [
    gnumake
    gcc
    bc
    bison
    flex
    perl
    python3
  ];

  installPhase = "cp .config $out";
  buildPhase = ''
    export ARCH=arm64

    cp arch/arm64/configs/sdm845.config .config

    make $makeFlags ARCH=arm64 olddefconfig
    patchShebangs scripts/config
    scripts/config ${lib.concatStringsSep " " config}
    make $makeFlags ARCH=arm64 olddefconfig
  '';

  passthru = {
    inherit localVer patches;
    version = kernelData.sdm845.version;
  };
}
