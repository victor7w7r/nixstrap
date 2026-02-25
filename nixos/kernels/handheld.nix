{
  lib,
  pkgs,
  fetchFromGitHub,
  linux_6_12,
  buildLinux,
  ...
}:
let
  variant = "deckify";
  localVer = "-v7w7r-handheld";
  lto = (pkgs.callPackage ./lib/lto.nix { });
  kernelConfig = import ./custom/kernel-config.nix { inherit fetchFromGitHub variant; };
  kconfigClearence = import ./kconfig-hack.nix {
    runCommand = pkgs.runCommand;
    inherit kernelConfig;
  };
  structuredExtraConfig = import ./lib/struct-config.nix {
    inherit lib;
    isAsus = true;
    zen4 = true;
    v3 = false;
  };
  patchedSrc = pkgs.callPackage ./custom/source.nix {
    asus = true;
    acpiCall = true;
    handheld = true;
    baseKernel = linux_6_12;
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
    pname = "linux-cachyos-handheld";
    defconfig = "cachyos_defconfig";
    inherit structuredExtraConfig;
    src = patchedSrc;
    stdenv = lto.stdenvLLVM;
    version = lib.versions.pad 3 "${linux_6_12.versionLTS}${localVer}";
    ignoreConfigErrors = true;
    extraPassthru = {
      packages = pkgs.linuxKernel.packagesFor kernel;
      inherit kconfigClearence;
    };
  };
in
lto.kernelModuleLLVMOverride (pkgs.linuxKernel.packagesFor kernel)
