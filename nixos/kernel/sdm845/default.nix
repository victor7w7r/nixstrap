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

      postInstall = ''
        echo ":: Installing Image.gz kernel"
        cp -v "$buildRoot/arch/arm64/boot/Image.gz" "$out/Image.gz"
        ln -sv Image.gz "$out/vmlinuz" || true
        depmod -b "$out" -F "$buildRoot/System.map" "${configure.version}"
      '';
    }).overrideAttrs
      (attrs: {
        passthru = attrs.passthru // {
          inherit kconfigToNix configure;
        };

        configurePhase = ''
          runHook preConfigure

          cp ${kconfigFile} .config
          chmod +w .config
          make olddefconfig

          runHook postConfigure
        '';
      });
}
