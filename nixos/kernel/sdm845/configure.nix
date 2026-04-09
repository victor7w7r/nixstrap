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
    "${fetch.patches}/${majorMinor}/misc/0001-bore-cachy.patch"
    "${fetch.patches}/${majorMinor}/misc/poc-selector.patch"
    "${fetch.patches}/${majorMinor}/misc/reflex-governor.patch"
    "${fetch.patches}/${majorMinor}/misc/nap-governor.patch"
    "${fetch.patches}/${majorMinor}/0002-bbr3.patch"
    "${fetch.patches}/${majorMinor}/0003-cachy.patch"
    "${fetch.patches}/${majorMinor}/0004-fixes.patch"
  ];
in
pkgs.stdenv.mkDerivation {
  inherit patches;
  src = fetch.sdm845;
  name = "linux-${majorMinor}${localVer}-config";

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
    version = kernelData.linux.version;
  };
}
