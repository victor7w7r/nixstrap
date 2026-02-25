{
  lib,
  pkgs,
  buildLinux,
  inputs,
  fetchurl,
  stdenv,
  ...
}@args:
let
  version = "6.18.13";
  localversion = "v7w7r-rog";
  config = pkgs.callPackage ./lib/config.nix {
    inherit localversion;
  };
  lto = pkgs.callPackage ./lib/lto.nix { };
  simplify = pkgs.callPackage ./lib/simplify.nix { };
  source = (pkgs.callPackage ./lib/patches.nix) {
    inherit inputs version;
    configVariant = "linux-cachyos-deckify";
    handheld = true;
    acpiCall = true;
    asus = true;
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v${lib.versions.major version}.x/linux-${version}.tar.xz";
      hash = "sha256-7Sw8Vf045oNsCU/ONW8lZ/lRYTC3M1SimFeWA2jFaH8=";
    };
  };
in
buildLinux (
  args
  // {
    autoModules = true;
    inherit version;
    pname = "linux-v7w7r-rog";
    modDirVersion = args.modDirVersion or "${lib.versions.pad 3 version}${localversion}";

    structuredExtraConfig =
      config.common
      # simplify.general
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
