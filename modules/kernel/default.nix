{
  inputs,
  kernel,
  lib,
  ...
}:
{
  imports = [ (inputs.den.namespace "kernel" true) ];
  flake-file.inputs.nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

  kernel.lib.v7w7r =
    {
      pkgs,
      patches,
      localVer,
      extraConfig,
      isHardened ? false,
      isArm ? false,
      isCachyos ? true,
      notDenial ? false,
    }:
    let
      src = if isCachyos then inputs.cachyos-linux else pkgs.linuxPackages_6_18.kernel.src;
    in
    (pkgs.buildLinux {
      pname = "linux-v7w7r-${localVer}";
      inherit src;
      stdenv = (pkgs.callPackage "${inputs.nix-cachyos-kernel.outPath}/helpers.nix" { }).stdenvLLVM;
      extraConfig = kernel.lib.concat-config {
        isString = true;
        config =
          (
            if (!notDenial) then
              (kernel.config.denial.all {
                inherit isArm;
                config = kernel.lib.cachyos-config pkgs isHardened;
              })
            else
              [ ]
          )
          ++ extraConfig;
      };

      version = (kernel.lib.version pkgs src localVer).final;
      modDirVersion = (kernel.lib.version pkgs src localVer).final;

      ignoreConfigErrors = true;
      kernelPatches = map (file: {
        name = baseNameOf (toString file);
        patch = file;
      }) patches;

      features = lib.optionalAttrs (!isArm) {
        ia32Emulation = true;
        netfilterRPFilter = true;
        efiBootStub = true;
      };

      extraMakeFlags = [
        "LOCALVERSION=-v7w7r-${localVer}"
        "NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING=1"
        "NIX_ENFORCE_NO_NATIVE=0"
        #"KCFLAGS=-Wno-unknown-warning-option -Wno-ignored-optimization-argument"
        #"CC=ccache cc"
        #"HOSTCC=ccache cc"
      ];
    })
    |> (base: {
      kernel = base;
      config = kernel.lib.filtered-config pkgs base.configfile;
      packages =
        base
        |> pkgs.linuxPackagesFor
        |> (pkgs.callPackage "${inputs.nix-cachyos-kernel.outPath}/helpers.nix" { })
          .kernelModuleLLVMOverride;
    });
}
/*
  lib.optionalAttrs isClang {
    nativeBuildInputs = (attrs.nativeBuildInputs or [ ]) ++ [ pkgs.ccache ];
  };
  }
*/
