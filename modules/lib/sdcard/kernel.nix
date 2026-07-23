{ lib, ... }:
{
  sdcard.lib.kernel = pkgs: ubootSelector: postBuildCommands: isEntireDisk: onlyKernel: ''
    ${(lib.optionalString onlyKernel "mkdir -p $out")}
    ${
      if ubootSelector == "sunxi" then
        (pkgs.buildUBoot {
          defconfig = "orangepi_zero2w_defconfig";
          extraMeta.platforms = [ "aarch64-linux" ];
          env.BL31 = "${pkgs.armTrustedFirmwareAllwinnerH616}/bl31.bin";
          filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
        })
        |> (uboot: ''
          echo "Copying uboot..."
          dd if=${uboot}/u-boot-sunxi-with-spl.bin of=boot.img bs=1024 seek=8 conv=notrunc
          sgdisk -v boot.img || true
          sgdisk -e boot.img || true
        '')
      else
        ""
    }
    ${postBuildCommands}
    ${lib.optionalString (
      !isEntireDisk
    ) "zstd -T$NIX_BUILD_CORES --rm boot.img && cp -a ./boot.img.zst $out/"}
  '';
}
