{
  helpers,
  host,
  lib,
  pkgs,
  hardened ? false,
  ...
}:
let
  source = pkgs.callPackage ./source.nix { inherit hardened host; };

  nativeHost =
    if host == "v7w7r-macmini81" then
      "-i7-8700B"
    else if host == "v7w7r-youyeetoox1" then
      "-server-N5105"
    else if host == "v7w7r-rc71l" then
      "-handheld-Ryzen-Z1"
    else
      "-v2";

  localVer = "-v7w7r${nativeHost}${if hardened then "-hardened" else ""}${
    if host == "v7w7r-youyeetoox1" || host == "v7w7r-macmini81" then "-zfs" else ""
  }";

  kernel =
    (pkgs.linuxManualConfig {
      src = source.src;
      version = lib.versions.pad 3 "${source.version}${localVer}";
      allowImportFromDerivation = false;
      modDirVersion = source.version;
      stdenv = helpers.stdenvLLVM;
      env.NIX_ENFORCE_NO_NATIVE = "0";

      extraMakeFlags = [
        "NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING=1"
        "KCFLAGS=-Wno-error"
      ];
    }).overrideAttrs
      (attrs: {
        passthru = attrs.passthru // {
          modDirVersion = source.version;
          features = {
            ia32Emulation = true;
            netfilterRPFilter = true;
            efiBootStub = true;
          };
        };
      });
in
{
  inherit kernel;
  packages =
    (pkgs.linuxPackagesFor kernel).extend (
      final: prev: {
        kernel_configfile = prev.kernel.configfile;
      }
    )
    |> removeAttrs [ ];
}
