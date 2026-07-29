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
      notDenial ? false,
      class ? "",
      dtbMake ? "",
      extra ? "",
    }:
    (pkgs.stdenvNoCC.mkDerivation {
      name = "linux-mod-src";
      src =
        (pkgs.linuxKernel.kernels.linux_7_1.override {
          argsOverride = {
            src = pkgs.fetchurl {
              url = "mirror://kernel/linux/kernel/v7.x/linux-7.1.5.tar.xz";
              sha256 = "sha256-IqAZazy83zTcJ7d1YfTQQFhf00R+3JqzUxoax54wQec=";
            };
            version = "7.1.5";
            modDirVersion = "7.1.5";
          };
        }).src;

      dontBuild = true;
      dontConfigure = true;

      postPatch = ''
        ${lib.optionalString (class != "") ''
          find "./arch/arm64/boot/dts" -mindepth 1 -maxdepth 1 -type d ! -name "${class}" -exec rm -rf {} +
          cat <<EOF > "./arch/arm64/boot/dts/Makefile"
              subdir-y += ${class}
          EOF
          cat <<EOF > "./arch/arm64/boot/dts/${class}/Makefile"
              ${dtbMake}
          EOF
        ''}
        ${extra}
      '';
      installPhase = ''
        mkdir -p $out
        cp -r . $out/
      '';

    }).src
    |> (
      src:
      pkgs.buildLinux {
        pname = "linux-v7w7r-${localVer}";
        inherit src;
        stdenv = pkgs.ccacheStdenv.override {
          stdenv = (pkgs.callPackage "${inputs.cachyos-kernel.outPath}/helpers.nix" { }).stdenvLLVM;
        };
        version = (kernel.lib.version pkgs src localVer).final;
        modDirVersion = (kernel.lib.version pkgs src localVer).final;
        ignoreConfigErrors = true;
        enableParallelBuilding = true;
        kernelPatches = map (file: {
          name = baseNameOf (toString file);
          patch = file;
        }) patches;

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
          "-j8"
        ];
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
