{
  helpers,
  host,
  lib,
  pkgs,
  kernelData,
  ...
}:
let
  configure = pkgs.callPackage ./configure.nix {
    inherit
      host
      kernelData
      helpers
      ;
  };

  kconfigToNix = pkgs.callPackage ./generated/generate.nix { inherit configure; };
  patches = configure.passthru.patches;
  kernel =
    (pkgs.linuxManualConfig {
      inherit (configure) src;
      config = (import ./generated) { inherit host; };
      configfile = configure;
      allowImportFromDerivation = false;
      version = lib.versions.pad 3 "${configure.version}${configure.passthru.localVer}";
      modDirVersion = lib.versions.pad 3 "${configure.version}${configure.passthru.localVer}";
      stdenv = helpers.stdenvLLVM;

      kernelPatches = builtins.map (file: {
        name = builtins.baseNameOf (toString file);
        patch = /. + file;
      }) patches;

      extraMakeFlags = [
        "NIX_ENFORCE_NO_NATIVE=0"
        "LOCALVERSION=${configure.passthru.localVer}"
        "NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING=1"
        "KCFLAGS=-Wno-error"
      ];
    }).overrideAttrs
      (attrs: {
        passthru = attrs.passthru // {
          inherit kconfigToNix configure;
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
