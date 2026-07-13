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
      localVer,
      config,
      extraConfig,
      patches,
      pkgs,
      isArm ? false,
      src,
      version,
    }:
    (pkgs.buildLinux {
      pname = "linux-v7w7r-${localVer}";
      inherit src;
      extraConfig = kernel.lib.concat-config {
        config =
          extraConfig ++ kernel.config.denial.all ++ (kernel.config.denial.dynamic { inherit config isArm; });
        isString = true;
      };
      version = "${version}-v7w7r-${localVer}";
      modDirVersion = "${version}-v7w7r-${localVer}";
      stdenv = (pkgs.callPackage "${inputs.nix-cachyos-kernel.outPath}/helpers.nix" { }).stdenvLLVM;
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
      packages =
        base
        |> pkgs.linuxPackagesFor
        |> (pkgs.callPackage "${inputs.nix-cachyos-kernel.outPath}/helpers.nix" { })
          .kernelModuleLLVMOverride;
      config = pkgs.stdenvNoCC.mkDerivation {
        name = "filtered-config";
        src = base.configfile;
        phases = [ "installPhase" ];
        installPhase = ''
          cp $src .config
          sed -i '/^[[:space:]]*#/d; /^[[:space:]]*$/d' .config
          sed -i -E 's/[[:space:]]+"\s*$/"/' .config
          mv .config $out
        '';
      };
    });

  perSystem =
    { pkgs, ... }:
    {
      packages = lib.mkAfter {
        handheld-kernel = (kernel.hosts.handheld pkgs).handheld-kernel;
        handheld-config = (kernel.hosts.handheld pkgs).handheld-config;
        server-kernel = (kernel.hosts.server pkgs).server-kernel;
        server-config = (kernel.hosts.server pkgs).server-config;
        pizero-kernel = (kernel.hosts.pizero pkgs).pizero-kernel;
        pizero-config = (kernel.hosts.pizero pkgs).pizero-config;
        superlab-config = (kernel.hosts.superlab pkgs).superlab-config;
        superlab-kernel = (kernel.hosts.superlab pkgs).superlab-kernel;
        generic-config = (kernel.hosts.generic pkgs).generic-config;
        generic-kernel = (kernel.hosts.generic pkgs).generic-kernel;
      };
    };
}
/*
  lib.optionalAttrs isClang {
    nativeBuildInputs = (attrs.nativeBuildInputs or [ ]) ++ [ pkgs.ccache ];
  };
  }
*/
