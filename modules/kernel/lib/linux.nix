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
      structuredExtraConfig ? { },
      armCross ? false,
      isArm ? false,
      class ? "",
      dtbMake ? "",
    }:

    if class != "" then
      (kernel.lib.arm-wrapper pkgs class dtbMake)
    else
      inputs.linux
      |> (
        src:
        pkgs.buildLinux {
          inherit src structuredExtraConfig;
          pname = "linux-v7w7r-${localVer}";
          features = lib.optionalAttrs (!isArm) {
            ia32Emulation = true;
            netfilterRPFilter = true;
            efiBootStub = true;
          };
          version = (kernel.lib.version pkgs src localVer).final;
          modDirVersion = (kernel.lib.version pkgs src localVer).final;
          ignoreConfigErrors = true;
          enableParallelBuilding = true;
          nativeBuildInputs = with pkgs; [ rustfmt ];

          kernelPatches = map (file: {
            name = baseNameOf (toString file);
            patch = file;
          }) patches;

          stdenv =
            (pkgs.callPackage "${inputs.cachyos-kernel.outPath}/helpers.nix" { }).stdenvLLVM
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
            );

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
        packages =
          base
          |> pkgs.linuxPackagesFor
          |> (pkgs.callPackage "${inputs.cachyos-kernel.outPath}/helpers.nix" { }).kernelModuleLLVMOverride;
        config = (
          pkgs.stdenvNoCC.mkDerivation {
            name = "filtered-config";
            src = base.configfile;
            phases = [ "installPhase" ];
            installPhase = ''
              cp $src .config
              sed -i '/^[[:space:]]*#/d; /^[[:space:]]*$/d' .config
              sed -i -E 's/[[:space:]]+"\s*$/"/' .config
              mv .config $out
            '';
          }
        );
      });
}
