{
  host,
  lib,
  pkgs,
  buildLinux,
  hardened ? false,
  ...
}:
let
  structuredExtraConfig =
    (import ./config.nix) { inherit host lib; } // (pkgs.callPackage ./simplify.nix { }).general;
  helpers = (pkgs.callPackage ./helpers.nix { });
  kernelConfig = (pkgs.callPackage ./kernel-config.nix { inherit hardened; });
  source = (pkgs.callPackage ./source.nix { inherit hardened host; });

  nativeHost =
    if host == "v7w7r-macmini81" then
      "-i7-8700B"
    else if host == "v7w7r-youyeetoox1" then
      "-server-N5105"
    else if host == "v7w7r-rc71l" then
      "-handheld-Ryzen-Z1"
    else
      "-v2";

  zfsHosts = host == "v7w7r-youyeetoox1" || host == "v7w7r-macmini81";
  localVer = "-v7w7r${nativeHost}${if hardened then "-hardened" else ""}${
    if zfsHosts then "-zfs" else ""
  }";

  kernel = buildLinux {
    # autoModules = false;
    pname = "linux-${nativeHost}";
    defconfig = "cachyos_defconfig";
    inherit structuredExtraConfig;
    src = source.src;
    stdenv = helpers.stdenvLLVM;
    ignoreConfigErrors = true;
    version = source.baseKernel.version;
    modDirVersion = lib.versions.pad 3 "${source.baseKernel.version}${localVer}";
    extraPassthru = {
      packages = pkgs.linuxKernel.packagesFor kernel;
      kconfigClearence = kernelConfig.kconfig;
    };
  };
in
kernel
