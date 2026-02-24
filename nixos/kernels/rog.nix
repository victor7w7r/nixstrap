{
  lib,
  inputs,
  callPackage,
  buildLinux,
  kernelPatches,
  applyPatches,
  fetchurl,
  stdenv,
  ...
}@args:
let
  version = "6.12.74";
  config = (import ./lib/config.nix) { };
  lto = (callPackage ./lib/lto.nix { });

  #simplify = (import ./lib/simplify) { };
  source = (import ./lib/patches.nix) {
    inherit
      lib
      version
      inputs
      kernelPatches
      applyPatches
      ;
    configVariant = "linux-cachyos-deckify";
    handheld = true;
    acpiCall = true;
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v${lib.versions.major version}.x/linux-${version}.tar.xz";
      hash = "sha256-bQiAO5U8UJ30jUTTKB7TklJDIdi7NT6yHAVVeQyPjgY=";
    };
  };
in
buildLinux (
  args
  // {
    #autoModules = true;
    inherit version;
    pname = "linux-v7w7r-rog";

    modDirVersion = args.modDirVersion or "${lib.versions.pad 3 version}-v7w7r-rog";

    structuredExtraConfig =
      config.common
      // config.bore
      // config.procOpt.zen4
      // config.lto.thin
      // config.preemptType.full
      // config.tickrate.full
      // (args.structuredExtraConfig or { });

    stdenv = lto.stdenvLLVM;
    extraMakeFlags = args.extraMakeFlags or [ ];
    defconfig = args.defconfig or "cachyos_defconfig";
    ignoreConfigErrors = args.ignoreConfigErrors or true;
    src = source.patchedSrc;
    extraMeta = {
      description = "Linux 7w7r Rog Kernel";
      broken = !stdenv.isx86_64;
    }
    // (args.extraMeta or { });
    extraPassthru = {
      cachyosConfigFile = source.cachyosConfigFile;
      cachyosPatches = source.cachyosPatches;
    }
    // (args.extraPassthru or { });
  }
)
