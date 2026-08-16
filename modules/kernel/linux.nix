{ inputs, kernel, ... }:
{
  kernel.lib.linux =
    {
      pkgs,
      host,
      isArm ? false,
      src,
      patches ? [ ],
      defconfig ? "cachyos_defconfig",
      localVer ? "native",
      legacy ? false,
      structuredExtraConfig ? { },
    }:
    pkgs.buildLinux {
      inherit src structuredExtraConfig defconfig;
      pname = "linux-v7w7r-${localVer}";
      version = (kernel.lib.version pkgs src localVer).final;
      modDirVersion = (kernel.lib.version pkgs src localVer).final;
      ignoreConfigErrors = true;
      enableCommonConfig = false;
      kernelArch = if isArm then "arm64" else null;
      kernelPatches = map (file: {
        name = baseNameOf (toString file);
        patch = file;
      }) patches;

      features = pkgs.lib.optionalAttrs (!isArm) {
        ia32Emulation = true;
        netfilterRPFilter = true;
        efiBootStub = true;
      };

      stdenv =
        if legacy then
          pkgs.gcc13Stdenv
        else
          (pkgs.callPackage "${inputs.cachyos-kernel.outPath}/helpers.nix" { }).stdenvLLVM
          |> (
            custStdenv:
            custStdenv.override {
              cc = pkgs.ccacheWrapper.override {
                cc = custStdenv.cc;
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
        "CCACHE_COMPILERCHECK=content"
        "DTC_FLAGS=-Wno-unique_unit_address"
        "KCFLAGS=-w"
        "LOCALVERSION=-v7w7r-${localVer}"
        "NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING=1"
        "NIX_ENFORCE_NO_NATIVE=0"
      ];
    }
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
