{
  helpers,
  host,
  lib,
  pkgs,
  buildLinux,
  hardened ? false,
  ...
}:
let
  kernelConfig = pkgs.callPackage ./kernel-config.nix { inherit hardened host; };
  source = pkgs.callPackage ./source.nix { inherit hardened host kernelConfig; };

  nativeHost =
    if host == "v7w7r-macmini81" then
      "-i7-8700B"
    else if host == "v7w7r-youyeetoox1" then
      "-server-N5105"
    else if host == "v7w7r-rc71l" then
      "-handheld-Ryzen-Z1"
    else
      "-v2";

  # builtins.trace "${host}"
  localVer = "-v7w7r${nativeHost}${if hardened then "-hardened" else ""}${
    if host == "v7w7r-youyeetoox1" || host == "v7w7r-macmini81" then "-zfs" else ""
  }";

  config = import ./config { inherit host; };

  commonDb = ./config/mod-common.db;
  modprobedDb =
    if host == "v7w7r-macmini81" then
      ./config/mod-macmini.db
    else if host == "v7w7r-youyeetoox1" then
      ./config/mod-server.db
    else if host == "v7w7r-rc71l" then
      ./config/mod-rc71l.db
    else
      commonDb;

  kernel = buildLinux {
    pname = "linux";
    defconfig = "cachyos_defconfig";
    ignoreConfigErrors = true;
    autoModules = false;
    src = source.src;
    stdenv = helpers.stdenvLLVM;
    modDirVersion = source.version;
    env.NIX_ENFORCE_NO_NATIVE = "0";

    preConfigure = ''
      #modprobed-db && e ~/.config/modprobed-db.conf && modprobed-db store && modprobed-db list
      cp "${kernelConfig.config}" ".config"

      export LSMOD=$(mktemp)
      awk '{ print $1, 0, 0 }' ${modprobedDb} ${commonDb} > $LSMOD
      (yes "" | make localmodconfig) || true

      make ARCH=x86_64 olddefconfig
      scripts/config ${lib.concatStringsSep " " config}
      make ARCH=x86_64 olddefconfig
    '';

    extraMakeFlags = [
      "NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING=1"
      "KCFLAGS=-Wno-error"
    ];
    version = lib.versions.pad 3 "${source.version}${localVer}";
    extraPassthru = {
      packages = pkgs.linuxKernel.packagesFor kernel;
      kconfigClearence = kernelConfig.kconfig;
    };
  };
in
kernel
