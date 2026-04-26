{
  lib,
  pkgs,
  kernel,
  kernelData,
  ...
}:
let
  majorMinor = lib.versions.majorMinor kernelData.linux.version;
  fetch = (
    pkgs.callPackage ../fetch.nix {
      inherit kernelData majorMinor;
    }
  );
  localVer = "-v7w7r-sunxi-hardened";
  config = (import ./config.nix);
  modules = ./modules.db;

  patchesRoute = "${fetch.armbian}/patch/kernel/archive/sunxi-6.18";
  patchLines = lib.splitString "\n" (builtins.readFile "${patchesRoute}/series.conf");
  patchesList = lib.filter (line: line != "" && !(lib.hasPrefix "#" line || lib.hasPrefix "-" line)) (
    map lib.strings.trim patchLines
  );
  selectedPatches = map (path: [ "${patchesRoute}/${path}" ]) patchesList;

  patches = selectedPatches ++ [
    "${fetch.patches}/${majorMinor}/misc/0001-hardened.patch"
    "${fetch.patches}/${majorMinor}/misc/reflex-governor.patch"
    "${fetch.patches}/${majorMinor}/misc/nap-governor.patch"
  ];
in

pkgs.stdenv.mkDerivation {
  inherit patches;
  src = fetch.linux;
  name = "linux-${majorMinor}${localVer}-config";

  nativeBuildInputs = kernel.nativeBuildInputs ++ kernel.buildInputs;
  installPhase = "cp .config $out";
  buildPhase = ''
    export ARCH=arm64

    cp ${./orangepi_defconfig} ./orangepi_defconfig
    make orangepi_defconfig

    cp "${./sunxi64.config}" ".config"
    make $makeFlags olddefconfig

    export LSMOD=$(mktemp)
    cat "${modules}" | sort > $LSMOD
    (yes "" | make LSMOD=$LSMOD localmodconfig) || true

    patchShebangs scripts/config
    scripts/config ${lib.concatStringsSep " " config}
    make $makeFlags olddefconfig
  '';

  meta = pkgs.linuxPackages.kernel.passthru.configfile.meta // {
    platforms = [ "aarch64-linux" ];
  };

  passthru = {
    version = kernelData.linux.version;
    inherit localVer patches;
  };
}
