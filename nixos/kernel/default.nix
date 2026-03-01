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

  kernel =
    (pkgs.linuxManualConfig {
      src = source.src;
      configFile = source;
      allowImportFromDerivation = true;
      modDirVersion = lib.versions.pad 3 "${source.version}${source.passthru.localVer}";
      stdenv = helpers.stdenvLLVM;
      env.NIX_ENFORCE_NO_NATIVE = "0";

      kernelPatches = builtins.map (file: {
        name = builtins.baseNameOf file;
        patch = file;
      }) source.passthru.kernelPatches;

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
  packages = pkgs.linuxPackagesFor kernel;
}
