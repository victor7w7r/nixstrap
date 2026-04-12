{
  pkgs,
  kernelData,
  ...
}:
let
  configure = pkgs.callPackage ./configure.nix {
    inherit kernelData kernel;
  };

  kconfigToNix = pkgs.callPackage ../generated/generate.nix { inherit configure; };
  patches = configure.passthru.patches;
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

      extraMakeFlags = [
        "LOCALVERSION=${configure.passthru.localVer}"
        "NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING=1"
        "NIX_ENFORCE_NO_NATIVE=0"
        "KCFLAGS=-Wno-unknown-warning-option -Wno-ignored-optimization-argument"
      ];
    }).overrideAttrs
      (attrs: {
        passthru = attrs.passthru // {
          inherit kconfigToNix configure;
        };
      });
in
{
  inherit kernel;
  packages = pkgs.linuxPackagesFor kernel;
}
