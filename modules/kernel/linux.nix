{ inputs, kernel, ... }: {

  kernel.lib.linux =
    {
      pkgs,
      host,
      patches ? [ ],
      localVer ? "native",
      structuredExtraConfig ? { },
      isHardened ? false,
      armCross ? false,
      defconfig ? null,
      isArm ? false,
      class ? null,
      dtbMake ? null,
    }:
    (kernel.lib.kernel-wrapper pkgs defconfig class dtbMake isHardened)
    |> (
      src:
      pkgs.buildLinux {
        inherit src structuredExtraConfig;
        pname = "linux-v7w7r-${localVer}";
        version = (kernel.lib.version pkgs src localVer).final;
        modDirVersion = (kernel.lib.version pkgs src localVer).final;
        ignoreConfigErrors = true;
        enableCommonConfig = false;
        defconfig = if (!isArm) then "cachyos_defconfig" else "armcust_defconfig";
        kernelArch = if armCross then "arm64" else null;
        kernelPatches =
          with kernel.patches.injector pkgs;
          map (file: {
            name = baseNameOf (toString file);
            patch = file;
          }) (cachyos.std ++ (bunker { }) ++ tachyon ++ patches);

        features = pkgs.lib.optionalAttrs (!isArm) {
          ia32Emulation = true;
          netfilterRPFilter = true;
          efiBootStub = true;
        };

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
        ];
      }
    )
    |> (base: {
      "${host}-kernel" = base;
      "${host}-allconfig" = base.configfile;
      "${host}-kernelPackages" =
        base
        |> pkgs.linuxPackagesFor
        |> (pkgs.callPackage "${inputs.cachyos-kernel.outPath}/helpers.nix" { }).kernelModuleLLVMOverride;
      "${host}-config" = pkgs.runCommand "filtered-config" { } ''
        cp ${base.configfile} .config
        sed -i '/^[[:space:]]*#/d; /^[[:space:]]*$/d' .config
        sed -i -E 's/[[:space:]]+"\s*$/"/' .config
        mv .config $out
      '';
    });
}
