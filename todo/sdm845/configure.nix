{
  lib,
  pkgs,
  stdenv,
  kernelData,
  ...
}:
let
  version = rec {
    file = "${fetch.sdm845}/Makefile";
    version = toString (builtins.match ".+VERSION = ([0-9]+).+" (builtins.readFile file));
    patchlevel = toString (builtins.match ".+PATCHLEVEL = ([0-9]+).+" (builtins.readFile file));
    sublevel = toString (builtins.match ".+SUBLEVEL = ([0-9]+).+" (builtins.readFile file));
    extraversionRaw = builtins.match ".*EXTRAVERSION = ([^\n\r]+).*" (builtins.readFile file);
    extraversion =
      if extraversionRaw != null then lib.strings.trim (builtins.head extraversionRaw) else "";
    string = "${
      version + "." + patchlevel + "." + sublevel + (lib.optionalString (extraversion != "") extraversion)
    }";
  };
  majorMinor = lib.versions.majorMinor version.string;

  isCross = stdenv.hostPlatform != stdenv.buildPlatform;
  fetch = (pkgs.callPackage ../fetch.nix { inherit kernelData majorMinor; });
  localVer = "-v7w7r-sdm845";
  config = (import ./config.nix);
  patches = [
    #"${fetch.patches}/${majorMinor}/misc/reflex-governor.patch"
    #"${fetch.patches}/${majorMinor}/misc/nap-governor.patch"
  ];
in
pkgs.stdenv.mkDerivation {
  inherit patches;
  src = fetch.sdm845;
  name = "linux-${majorMinor}${localVer}-config";
  stdenv = pkgs.gcc14Stdenv;
  nativeBuildInputs = with pkgs; [
    gnumake
    gcc14
    bc
    bison
    flex
    perl
    python3
  ];

  installPhase = "cp .config $out";
  makeFlags = [
    "ARCH=arm64"
  ]
  ++ lib.optionals isCross [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  buildPhase = ''
    export ARCH=arm64
    make defconfig
    if [ -f arch/arm64/configs/sdm845.config ]; then
        scripts/kconfig/merge_config.sh -m .config arch/arm64/configs/sdm845.config
    fi
    patchShebangs scripts/config
    scripts/config ${lib.concatStringsSep " " config}
    make $makeFlags olddefconfig
  '';

  meta = pkgs.linuxPackages.kernel.passthru.configfile.meta // {
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };

  passthru = {
    inherit localVer patches;
    version = version.string;
  };
}
