{
  lib,
  pkgs,
  fetchFromGitHub,
  linux_6_12_65,
  buildLinux,
  ...
}:
let
  variant = "lts";
  localVer = "-v7w7r-secured-server";
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
    baseKernel = linux_6_12_65;
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
    pname = "linux";
    defconfig = "cachyos_defconfig";
    inherit structuredExtraConfig;
    src = patchedSrc;
    stdenv = lto.stdenvLLVM;
    version = lib.versions.pad 3 "${linux_6_12_65.version}${localVer}";
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
