{
  lib,
  pkgs,
  fetchFromGitHub,
  buildLinux,
  fetchurl,
  ...
}:
let
  variant = "lts";
  localVer = "-v7w7r-secured-server";
  kernelSrc = import ./custom/kernel.nix { inherit lib fetchurl; };
  lto = (pkgs.callPackage ./lib/lto.nix { });
  simplify = pkgs.callPackage ./lib/simplify.nix { };
  kernelConfig = import ./custom/kernel-config.nix { inherit fetchFromGitHub variant; };
  kconfigClearence = import ./kconfig-hack.nix {
    runCommand = pkgs.runCommand;
    inherit kernelConfig;
  };
  structuredExtraConfig =
    import ./lib/struct-config.nix {
      inherit lib;
      isBore = false;
      hasBbr3 = false;
      isServer = true;
      v2 = true;
      v3 = false;
      preemptTypeFull = false;
      tickrateFull = false;
    }
    // simplify.general;
  patchedSrc = pkgs.callPackage ./custom/source.nix {
    cpusched = "eevdf";
    hardened = true;
    baseKernel = {
      src = kernelSrc.srcLTS;
      version = kernelSrc.versionLTS;
    };
    inherit
      lib
      fetchFromGitHub
      kernelConfig
      fetchGit
      variant
      ;
  };
  kernel = buildLinux {
    # autoModules = false;
    pname = "linux-cachyos-server";
    defconfig = "cachyos_defconfig";
    inherit structuredExtraConfig;
    src = patchedSrc;
    stdenv = lto.stdenvLLVM;
    version = lib.versions.pad 3 "${kernelSrc.versionLTS}${localVer}";
    ignoreConfigErrors = true;
    extraPassthru = {
      packages = pkgs.linuxKernel.packagesFor kernel;
      inherit kconfigClearence;
    };
  };
in
(lto.kernelModuleLLVMOverride (pkgs.linuxKernel.packagesFor kernel)).extend (
  _self: _super: { zfs_cachyos = pkgs.cachyosKernels.zfs-cachyos-lto.override { kernel = kernel; }; }
)
