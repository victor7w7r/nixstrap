{ lib, ... }:
{
  sdcard.lib.kernel = pkgs: ubootSelector: postBuildCommands: onlyKernel: ''
    echo "Copying uboot and compressing kernel image..."
    ${(lib.optionalString onlyKernel "mkdir -p $out")}
    ${
      if ubootSelector == "sunxi" then
        (pkgs.buildUBoot {
          defconfig = "orangepi_zero2w_defconfig";
          extraMeta.platforms = [ "aarch64-linux" ];
          filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
          version = "2024.04";
          src = pkgs.fetchurl {
            url = "https://ftp.denx.de/pub/u-boot/u-boot-2024.04.tar.bz2";
            hash = "sha256-GKhT/jn6160DqQzC1Cda6u1tppc13vrDSSuAUIhD3Uo=";
          };

          BL31 = "${pkgs.armTrustedFirmwareAllwinner}/bl31.bin";
        }).overrideAttrs
          (
            oldAttrs:
            let
              pyEnv = pkgs.python3.withPackages (
                p: with p; [
                  setuptools
                  pyelftools
                  libfdt
                ]
              );
            in
            {
              nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [
                pkgs.bc
                pkgs.dtc
                pkgs.armTrustedFirmwareTools
                pkgs.bison
                pkgs.flex
                pkgs.which
                pkgs.swig
                pkgs.openssl
                pyEnv
              ];

              preBuild = (oldAttrs.preBuild or "") + ''
                export PYTHON="${pyEnv}/bin/python3"
                export PYTHONPATH="${pyEnv}/${pkgs.python3.sitePackages}:$PYTHONPATH"
              '';
            }
          )
        |> (uboot: "dd if=${uboot}/u-boot-sunxi-with-spl.bin of=$bootImg bs=1024 seek=8 conv=notrunc")
      else
        ""
    }
    ${postBuildCommands}
    zstd -T$NIX_BUILD_CORES --rm boot.img && cp -a ./boot.img.zst $out/
  '';
}
