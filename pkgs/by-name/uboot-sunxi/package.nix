{ pkgs }:
pkgs.pkgsCross.aarch64-multiplatform.buildUBoot {
  defconfig = "orangepi_zero2w_defconfig";
  extraMeta.platforms = [ "aarch64-linux" ];
  env.BL31 = "${pkgs.pkgsCross.aarch64-multiplatform.armTrustedFirmwareAllwinnerH616}/bl31.bin";
  filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
}
