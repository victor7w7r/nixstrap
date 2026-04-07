{
  lib,
  pkgs,
  kernel,
  kernelData,
  ...
}:
let
  majorMinor = lib.versions.majorMinor kernelData.linux-org.version;
  fetch = (pkgs.callPackage ../fetch.nix { inherit kernelData; });
  prepare = (pkgs.callPackage ./prepare.nix { inherit kernel; });
  localVer = "-v7w7r-sunxi-hardened";
  config = (import ./config.nix);

  sunxiPatches = "${fetch.sunxi}/patches/uwe5622/armbian-sunxi-6.12";
  sunxiPaths = lib.filter (line: line != "" && !(lib.hasPrefix "#" line)) (
    map lib.strings.trim (
      lib.splitString "\n" (builtins.readFile (sunxiPatches + "/selected-for-opi-zero2w.list"))
    )
  );

  patches = (map (file: { patch = "${sunxiPatches}/${file}"; }) sunxiPaths) ++ [
    "${fetch.patches}/${majorMinor}/0002-bbr3.patch"
    "${fetch.patches}/${majorMinor}/0003-cachy.patch"
    "${fetch.patches}/${majorMinor}/0004-fixes.patch"
    "${fetch.patches}/${majorMinor}/0007-zstd.patch"
    "${fetch.patches}/${majorMinor}/misc/0001-hardened.patch"
  ];
in

pkgs.stdenv.mkDerivation (attrs: {
  inherit patches;
  src = fetch.linux;
  name = "linux-${majorMinor}${localVer}-config";

  nativeBuildInputs = kernel.nativeBuildInputs ++ [ pkgs.ccache ];

  preConfigure = prepare.preConfigure;
  postPatch = prepare.postPatch;

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
    inherit localVer patches;
  };
})
