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
      host,
      arch,
      system,
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
      kernelArch =
        if pkgs.stdenv.buildPlatform != pkgs.stdenv.hostPlatform && arch == "aarch64-linux" then
          "arm64"
        else if pkgs.stdenv.buildPlatform != pkgs.stdenv.hostPlatform && arch == "x86_64-linux" then
          "x86_64"
        else
          null;

      kernelPatches = map (file: {
        name = baseNameOf (toString file);
        patch = file;
      }) patches;

      features = pkgs.lib.optionalAttrs (arch != "aarch64-linux") {
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
                  export CCACHE_SLOPPINESS="time_macros,include_file_mtime,include_file_ctime,file_stat_matches"
                  export CCACHE_DIRECT=1
                  export CCACHE_READ_ONLY_FALLBACK=true
                '';
              };
            }
          );

      extraMakeFlags = [
        "CCACHE_COMPILERCHECK=content"
        "KCFLAGS=-w"
        "LOCALVERSION=-v7w7r-${localVer}"
        "NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING=1"
        "NIX_ENFORCE_NO_NATIVE=0"
        "ARCH=${if arch == "aarch64-linux" then "arm64" else "x86_64"}"
      ]
      ++ (lib.optional (system != arch) "CROSS_COMPILE=${pkgs.stdenv.hostPlatform.config}-");
    }
    |> (base: {
      "${host}-kernel" = base;
      "${host}-allconfig" = base.configfile;
      "${host}-kernelPackages" =
        if legacy then
          base |> pkgs.linuxPackagesFor
        else
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
