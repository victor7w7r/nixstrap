{
  host,
  lib,
  pkgs,
  buildLinux,
  hardened ? false,
  ...
}:
let
  structuredExtraConfig = (import ./config) { inherit host pkgs lib; };
  helpers = (pkgs.callPackage ./helpers.nix { });
  kernelConfig = (pkgs.callPackage ./kernel-config.nix { inherit hardened host; });
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
  # builtins.trace "${host}"
  localVer = "-v7w7r${nativeHost}${if hardened then "-hardened" else ""}${
    if zfsHosts then "-zfs" else ""
  }";

  kernel = buildLinux {
    pname = "linux";
    defconfig = "cachyos_defconfig";
    ignoreConfigErrors = true;
    autoModules = true;
    inherit structuredExtraConfig;
    src = source.src;

    nativeBuildInputs = with pkgs; [
      patch
      rustfmt
      rustc
      cargo
    ];

    NIX_ENFORCE_PURITY = 0;
    configureFlags = [ "--target=x86_64-unknown-linux-gnu" ];
    stdenv = helpers.stdenvLLVM;
    version = lib.versions.pad 3 "${source.version}${localVer}";
    extraPassthru = {
      packages = pkgs.linuxKernel.packagesFor kernel;
      kconfigClearence = kernelConfig.kconfig;
    };
  };
in
kernel
