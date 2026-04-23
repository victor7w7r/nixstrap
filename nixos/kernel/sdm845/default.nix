{
  lib,
  pkgs,
  kernelData,
  device ? "fajita",
  ...
}:
let
  configure = pkgs.callPackage ./configure.nix { inherit kernelData kernel; };
  kconfigToNix = pkgs.callPackage ../generated/generate.nix { inherit configure; };
  patches = configure.passthru.patches;
  uboot = pkgs.callPackage ./uboot.nix {
    inherit device kernel kernelData;
    inherit (configure) src;
  };
  kernel =
    (pkgs.linuxManualConfig {
      inherit (configure) src;
      config = (import ./config.aarch64-linux.nix);
      configfile = configure;
      allowImportFromDerivation = false;
      version = "${configure.version}${configure.passthru.localVer}";
      modDirVersion = "${configure.version}${configure.passthru.localVer}";

      kernelPatches = map (file: {
        name = baseNameOf (toString file);
        patch = file;
      }) patches;

      stdenv = lib.recursiveUpdate pkgs.stdenv {
        hostPlatform.linux-kernel.extraConfig = "";
      };

      extraMakeFlags = [
        "LOCALVERSION=${configure.passthru.localVer}"
        "NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING=1"
        "NIX_ENFORCE_NO_NATIVE=0"
        "KCFLAGS=-Wno-unknown-warning-option -Wno-ignored-optimization-argument"
      ];
    }).overrideAttrs
      (attrs: {
        passthru = attrs.passthru // {
          isModular = false;
          inherit kconfigToNix uboot configure;
          features = {
            isModular = false;
            efiBootStub = true;
          };
        };
      });
in
{
  inherit kernel;
  packages = pkgs.linuxPackagesFor kernel;
}
