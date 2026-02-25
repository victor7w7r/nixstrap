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
  version = "6.17.13";
  localversion = "v7w7r-server";
  config = pkgs.callPackage ./lib/config.nix { inherit localversion; };
  lto = pkgs.callPackage ./lib/lto.nix { };
  simplify = pkgs.callPackage ./lib/simplify.nix { };
  source = (pkgs.callPackage ./lib/patches.nix) {
    inherit inputs version;
    configVariant = "linux-cachyos-server";
    cpusched = "eevdf";
    hardened = true;
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v${lib.versions.major version}.x/linux-${version}.tar.xz";
      hash = "sha256-EWgC3DrRZGFjzG/+m926JKgGm1aRNewFI815kGTy7bk=";
    };
  };
in
buildLinux (
  args
  // {
    autoModules = true;
    inherit version;
    pname = "linux-v7w7r-server";
    modDirVersion = args.modDirVersion or "${lib.versions.pad 3 version}${localversion}";

    structuredExtraConfig =
      config.common
      // simplify.general
      // config.procOpt.x86_64-v2
      // config.bbr3
      // config.lto.thin
      // config.preemptType.none
      // config.hzTicks."300"
      // config.tickrate.idle
      // (args.structuredExtraConfig or { });

    stdenv = lto.stdenvLLVM;
    extraMakeFlags = args.extraMakeFlags or [ ];
    defconfig = args.defconfig or "cachyos_defconfig";
    ignoreConfigErrors = true;
    src = source.patchedSrc;
    extraMeta = {
      description = "Linux 7w7r Server Kernel";
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
