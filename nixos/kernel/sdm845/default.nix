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
      inherit (configure) src;
      configfile = configure;
      nativeBuildInputs = with pkgs; [
        python3
        zstd
        kmod
        gzip
      ];

      isModular = true;
      version = "${configure.version}${configure.passthru.localVer}";
      modDirVersion = "${configure.version}${configure.passthru.localVer}";
      makeImageDtbWith = "qcom/sdm845-oneplus-fajita.dtb";
      isCompressed = "gz";
      installTargets = [ "modules_install" ];
    }).overrideAttrs
      (attrs: {
        stdenv = pkgs.gcc14Stdenv.override {
          stdenv = pkgs.ccacheStdenv;
        };

        nativeBuildInputs = (attrs.nativeBuildInputs or [ ]) ++ [ pkgs.ccache ];
        passthru = attrs.passthru // {
          inherit kconfigToNix configure;
        };

        installTargets = [ "modules_install" ];
        installFlags = [
          "INSTALL_MOD_PATH=$(out)"
          "INSTALL_PATH=$(out)"
          "KBUILD_IMAGE=arch/arm64/boot/Image.gz"
        ];

        postInstall = ''
          mkdir -p $out

          if [ -f arch/arm64/boot/Image.gz ]; then
           cp -v arch/arm64/boot/Image.gz $out/Image.gz
          elif [ -f arch/arm64/boot/Image ]; then
            gzip -c arch/arm64/boot/Image > $out/Image.gz
          fi

          ln -sv Image.gz "$out/vmlinuz" || true
          cp .config $out/config-${configure.version}
          depmod -b $out -F System.map "${configure.version}${configure.passthru.localVer}"
        '';

        configurePhase = ''
          runHook preConfigure

          cp ${kconfigFile} .config
          chmod +w .config
          make olddefconfig

          runHook postConfigure
        '';
      });
in
{
  inherit build;
  packages = pkgs.linuxPackagesFor build;
}
