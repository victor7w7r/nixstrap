{
  lib,
  pkgs,
  fetchFromGitHub,
  buildLinux,
  linux_6_18,
  hardened ? false,
  isZfs ? true,
  isT2 ? false,
  ...
}:
let
  variant = "lts";
  localVer = "-v7w7r${
    if hardened then "-secured" else ""
  }${if isZfs then "-zfs" else ""}${if isT2 then "-apple" else ""}";
  lto = (pkgs.callPackage ./lib/lto.nix { });
  kernelConfig = import ./custom/kernel-config.nix { inherit fetchFromGitHub variant; };
  kconfigClearence = import ./kconfig-hack.nix {
    runCommand = pkgs.runCommand;
    inherit kernelConfig;
  };
  structuredExtraConfig = import ./lib/struct-config.nix { inherit lib; };
  patchedSrc = pkgs.callPackage ./custom/source.nix {
    baseKernel = linux_6_18;
    inherit
      lib
      fetchFromGitHub
      hardened
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
    version = lib.versions.pad 3 "${linux_6_18.version}${localVer}";
    ignoreConfigErrors = true;
    extraPassthru = {
      packages = pkgs.linuxKernel.packagesFor kernel;
      inherit kconfigClearence;
    };
  };
  readyKernel = lto.kernelModuleLLVMOverride (pkgs.linuxKernel.packagesFor kernel);
in
if isZfs then
  readyKernel.extend (
    _self: _super: { zfs_cachyos = pkgs.cachyosKernels.zfs-cachyos-lto.override { kernel = kernel; }; }
  )
else
  readyKernel
