{
  lib,
  pkgs,
  kernelData,
  ...
}:
let
  configure = pkgs.callPackage ./configure.nix { inherit kernelData; };
  kconfigToNix = pkgs.callPackage ../generated/generate.nix { inherit configure; };
  kconfigFile = pkgs.writeText "kconfig-mobile" (
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: value: "${name}=${value}") (import ./config.aarch64-linux.nix)
    )
  );
  build =
    (pkgs.mobile-nixos.kernel-builder {
      inherit (configure) patches src;
      configfile = configure;
      nativeBuildInputs = with pkgs; [
        python3
        zstd
        ccache
        kmod
        gzip
      ];

      isModular = true;
      enableRemovingWerror = true;
      installTargets = [ "modules_install" ];

      version = "${configure.version}${configure.passthru.localVer}";
      modDirVersion = "${configure.version}${configure.passthru.localVer}";
      makeImageDtbWith = "qcom/sdm845-oneplus-fajita.dtb";
      isCompressed = "gz";

      postInstall = ''
        mkdir -p $out

        cp -v "$buildRoot/arch/arm64/boot/Image.gz" "$out/Image.gz"

        ln -sv Image.gz "$out/vmlinuz" || true
        cp .config $out/config-${configure.version}

        depmod -b "$out" -F "$buildRoot/System.map" "${configure.version}"
      '';
    })

    .overrideAttrs
      (attrs: {
        ignoreConfigErrors = true;
        passthru = attrs.passthru // {
          inherit kconfigToNix configure;
        };

        /*
          installFlags = [ "INSTALL_MOD_PATH=$out" ];

          configurePhase = ''
            runHook preConfigure

            cp ${kconfigFile} .config
            chmod +w .config
            make olddefconfig

            runHook postConfigure
            '';
        */

      });

in
{
  inherit build;
  packages = pkgs.linuxPackagesFor build;
}
