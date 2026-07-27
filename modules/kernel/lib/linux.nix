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
      isHardened ? false,
      isArm ? false,
      isCachyos ? true,
      notDenial ? false,
    }:
    let
      src = if isCachyos then inputs.linux else pkgs.linuxPackages_7_1.kernel.src;
    in
    (pkgs.buildLinux {
      pname = "linux-v7w7r-${localVer}";
      inherit src;
      stdenv = (pkgs.callPackage "${inputs.cachyos-kernel.outPath}/helpers.nix" { }).stdenvLLVM;
      version = (kernel.lib.version pkgs src localVer).final;
      modDirVersion = (kernel.lib.version pkgs src localVer).final;
      ignoreConfigErrors = true;

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

      kernelPatches = map (file: {
        name = baseNameOf (toString file);
        patch = file;
      }) patches;

      # nativeBuildInputs = (attrs.nativeBuildInputs or [ ]) ++ [ pkgs.ccache ];

      features = lib.optionalAttrs (!isArm) {
        ia32Emulation = true;
        netfilterRPFilter = true;
        efiBootStub = true;
      };

      extraMakeFlags = [
        "LOCALVERSION=-v7w7r-${localVer}"
        "NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING=1"
        "NIX_ENFORCE_NO_NATIVE=0"
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
        |> (pkgs.callPackage "${inputs.cachyos-kernel.outPath}/helpers.nix" { }).kernelModuleLLVMOverride;
    });
}
