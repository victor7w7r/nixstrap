{
  inputs,
  kernel,
  lib,
  ...
}:
{
  kernel.lib.linux =
    {
      pkgs,
      patches,
      localVer,
      extraConfig,
      armCross ? false,
      isHardened ? false,
      isArm ? false,
      notDenial ? false,
      class ? "",
      dtbMake ? "",
      extra ? "",
    }:
    (kernel.lib.linux-wrapper {
      inherit
        pkgs
        class
        dtbMake
        extra
        ;
    })
    |> (
      src:
      pkgs.buildLinux {
        pname = "linux-v7w7r-${localVer}";
        inherit src;
        stdenv = (pkgs.callPackage "${inputs.cachyos-kernel.outPath}/helpers.nix" { }).stdenvLLVM
        /*
          |> (
          llvmStdenv:
          llvmStdenv.override {
            cc = pkgs.ccacheWrapper.override {
              cc = llvmStdenv.cc;
              extraConfig = ''
                export CCACHE_COMPRESS=1
                export CCACHE_DIR="/var/cache/ccache"
                export CCACHE_UMASK="007"
                export CCACHE_SLOPPINESS=random_seed
                export CCACHE_READ_ONLY_FALLBACK=true
              '';
            };
          }
          )
        */
        ;
        version = (kernel.lib.version pkgs src localVer).final;
        modDirVersion = (kernel.lib.version pkgs src localVer).final;
        ignoreConfigErrors = true;
        enableParallelBuilding = true;
        nativeBuildInputs = with pkgs; [ rustfmt ];
        kernelPatches = (
          map (file: {
            name = baseNameOf (toString file);
            patch = file;
          }) patches
        );

        extraConfig =
          with lib;
          (
            (
              if (!notDenial) then
                (kernel.config.denial.all {
                  inherit isArm;
                  config = kernel.lib.linux-config pkgs isHardened;
                })
              else
                [ ]
            )
            ++ extraConfig
          )
          |> map (structConfig: removeAttrs structConfig [ "__provider" ])
          |> zipAttrsWith (_: builtins.head)
          |> mapAttrsToList (option: value: "${option} ${value}")
          |> concatStringsSep "\n";

        features = lib.optionalAttrs (!isArm) {
          ia32Emulation = true;
          netfilterRPFilter = true;
          efiBootStub = true;
        };

        extraMakeFlags = [
          "LOCALVERSION=-v7w7r-${localVer}"
          "NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING=1"
          "NIX_ENFORCE_NO_NATIVE=0"
          "DTC_FLAGS=-Wno-unique_unit_address"
          "KCFLAGS=-w"
          "CCACHE_COMPILERCHECK=content"
          "-j8"
        ]
        ++ (lib.optionals armCross [
          "ARCH=arm64"
          "CROSS_COMPILE=aarch64-unknown-linux-gnu-"
        ]);
      }
    )

    |> (base: {
      kernel = base;
      config = kernel.lib.filtered-config pkgs base.configfile;
      packages =
        base
        |> pkgs.linuxPackagesFor
        |> (pkgs.callPackage "${inputs.cachyos-kernel.outPath}/helpers.nix" { }).kernelModuleLLVMOverride;
    });
}
