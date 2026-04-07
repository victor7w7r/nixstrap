{
  lib,
  pkgs,
  kernel,
  kernelData,
  ...
}:
let
  majorMinor = lib.versions.majorMinor kernelData.linux-legacy.version;
  fetch = (
    pkgs.callPackage ../fetch.nix {
      inherit kernelData majorMinor;
      isLegacy = true;
    }
  );
  prepare = (
    import ./prepare.nix {
      targetPrefix = pkgs.stdenv.cc.targetPrefix;
    }
  );
  preConfigure = prepare.preConfigure;
  postPatch = prepare.postPatch;
  localVer = "-v7w7r-sunxi-hardened";
  config = (import ./config.nix);

  sunxiPatches = "${fetch.sunxi}/patches/uwe5622/armbian-sunxi-6.12";
  sunxiPaths = lib.filter (line: line != "" && !(lib.hasPrefix "#" line)) (
    map lib.strings.trim (
      lib.splitString "\n" (builtins.readFile (sunxiPatches + "/selected-for-opi-zero2w.list"))
    )
  );

  patches = (map (file: "${sunxiPatches}/${file}") sunxiPaths) ++ [
    "${fetch.patches}/${majorMinor}/0002-bbr3.patch"
    "${fetch.patches}/${majorMinor}/0003-cachy.patch"
    "${fetch.patches}/${majorMinor}/0004-fixes.patch"
    "${fetch.patches}/${majorMinor}/0007-zstd.patch"
    "${fetch.patches}/${majorMinor}/misc/0001-hardened.patch"
  ];
in

pkgs.stdenv.mkDerivation (attrs: {
  inherit patches preConfigure postPatch;
  src = fetch.linux;
  name = "linux-${majorMinor}${localVer}-config";

  nativeBuildInputs = kernel.nativeBuildInputs ++ [ pkgs.ccache ];

  installPhase = "cp config $out";
  buildPhase = ''
    cp "${fetch.sunxi-kconfig}" ".config"

    make $makeFlags olddefconfig
    patchShebangs scripts/config
    scripts/config ${lib.concatStringsSep " " config}
    make $makeFlags olddefconfig
  '';

  meta = pkgs.linuxPackages.kernel.passthru.configfile.meta // {
    platforms = [ "aarch64-linux" ];
  };

  passthru = {
    version = kernelData.linux.version;
    inherit
      localVer
      patches
      preConfigure
      postPatch
      ;
  };
})
