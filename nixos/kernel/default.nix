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
      kernel
      helpers
      ;
  };

  kconfigToNix = pkgs.callPackage ./generated/generate.nix { inherit configure; };
  patches = configure.passthru.patches;
  kernel =
    (pkgs.linuxManualConfig rec {
      inherit (configure) src;
      config = (import ./generated) { inherit host; };
      configfile = configure;
      allowImportFromDerivation = false;
      version = lib.versions.pad 3 "${configure.version}${configure.passthru.localVer}";
      modDirVersion = lib.versions.pad 3 "${configure.version}${configure.passthru.localVer}";
      stdenv = pkgs.ccacheStdenv.override {
        stdenv = helpers.stdenvLLVM;
      };
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
        nativeBuildInputs = (attrs.nativeBuildInputs or [ ]) ++ [ pkgs.ccache ];
        /*
          patchPhase = ''
            export CCACHE_COMPRESS=1
            export CCACHE_DIR="/nix/var/cache/ccache"
            export CCACHE_SLOPPINESS=random_seed
            export CCACHE_UMASK=007
          ${attrs.buildPhase or ""}
          '';
        */
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
