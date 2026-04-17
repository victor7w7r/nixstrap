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
        "CC=${stdenv.cc}/bin/clang"
        #"LD=${stdenv.cc}/bin/ld.lld"
        #"HOSTLD=${stdenv.cc}/bin/ld.lld"
        "AR=${stdenv.cc}/bin/ar"
        "HOSTAR=${stdenv.cc}/bin/ar"
        "NM=${stdenv.cc}/bin/nm"
        "STRIP=${stdenv.cc}/bin/strip"
        "OBJCOPY=${stdenv.cc}/bin/objcopy"
        "OBJDUMP=${stdenv.cc}/bin/objdump"
        "READELF=${stdenv.cc}/bin/readelf"
        "HOSTCC=${stdenv.cc}/bin/clang"
        "HOSTCXX=${stdenv.cc}/bin/clang++"
        "KCFLAGS=-Wno-unknown-warning-option -Wno-ignored-optimization-argument"
      ];
    }).overrideAttrs
      (attrs: {
        nativeBuildInputs = (attrs.nativeBuildInputs or [ ]) ++ [ pkgs.ccache ];
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
  nixpkgs.overlays = [
    (self: super: {
      ccacheWrapper = super.ccacheWrapper.override {
        extraConfig = ''
          export CCACHE_COMPRESS=1
          export CCACHE_DIR="/nix/var/cache/ccache"
          export CCACHE_SLOPPINESS=random_seed
          export CCACHE_UMASK=007
          if [ ! -d "$CCACHE_DIR" ]; then
            echo "====="
            echo "Directory '$CCACHE_DIR' does not exist"
            echo "Please create it with:"
            echo "  sudo mkdir -m0770 '$CCACHE_DIR'"
            echo "  sudo chown root:nixbld '$CCACHE_DIR'"
            echo "====="
            exit 1
          fi
          if [ ! -w "$CCACHE_DIR" ]; then
            echo "====="
            echo "Directory '$CCACHE_DIR' is not accessible for user $(whoami)"
            echo "Please verify its access permissions"
            echo "====="
            exit 1
          fi
        '';
      };
    })
  ];
  inherit kernel;
  packages = pkgs.linuxPackagesFor kernel;
}
