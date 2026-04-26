{ pkgs }:
pkgs.buildUBoot {
  defconfig = "orangepi_zero2w_defconfig";
  extraMeta.platforms = [ "aarch64-linux" ];
  BL31 = "${pkgs.armTrustedFirmwareAllwinnerH616}/bl31.bin";
  version = "2024.04";
  filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  src = pkgs.fetchurl {
    url = "https://ftp.denx.de/pub/u-boot/u-boot-2024.04.tar.bz2";
    hash = "sha256-GKhT/jn6160DqQzC1Cda6u1tppc13vrDSSuAUIhD3Uo=";
  };
  nativeBuildInputs = with pkgs; [
    dtc
    armTrustedFirmwareTools
    bison
    flex
    which
    swig
    openssl
    (python3.withPackages (p: [
      p.setuptools
      p.libfdt
      p.pyelftools
    ]))
  ];
}
