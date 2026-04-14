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
in
{

  build =
    (pkgs.mobile-nixos.kernel-builder {
      inherit (configure) src;
      configfile = configure;
      nativeBuildInputs = with pkgs; [
        python3
        zstd
        kmod
      ];

      isModular = true;
      version = "${configure.version}${configure.passthru.localVer}";
      modDirVersion = "${configure.version}${configure.passthru.localVer}";
      isCompressed = "gz";
      installTargets = [ "modules_install" ];
    }).overrideAttrs
      (attrs: {
        passthru = attrs.passthru // {
          inherit kconfigToNix configure;
        };

        installTargets = [ "modules_install" ];
        installFlags = [
          "INSTALL_MOD_PATH=$(out)"
          "INSTALL_PATH=$(out)"
        ];

        postInstall = ''
          mkdir -p $out

          cp -v arch/arm64/boot/Image.gz $out/Image.gz
          ln -sv Image.gz "$out/vmlinuz" || true

          cp .config $out/config-${configure.version}
          depmod -b $out -F System.map "${configure.version}"

          make dtbs $makeFlags
          mkdir -p $out/dtbs/qcom
          cp arch/arm64/boot/dts/qcom/sdm845-oneplus-fajita.dtb $out/dtbs/qcom/
        '';

        configurePhase = ''
          runHook preConfigure

          cp ${kconfigFile} .config
          chmod +w .config
          make olddefconfig

          runHook postConfigure
        '';
      });
}
