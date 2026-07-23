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
          nativeBuildInputs = [
            pkgs.buildPackages.bison
            pkgs.buildPackages.flex
          ];
          BL31 = "${pkgs.armTrustedFirmwareAllwinnerH616}/bl31.bin";
          filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
        })
        |> (uboot: "dd if=${uboot}/u-boot-sunxi-with-spl.bin of=$bootImg bs=1024 seek=8 conv=notrunc")
      else
        ""
    }
    ${postBuildCommands}
    zstd -T$NIX_BUILD_CORES --rm boot.img && cp -a ./boot.img.zst $out/
  '';
}
