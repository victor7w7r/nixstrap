{
  buildPackages,
  lib,
  pkgs,
}:
(pkgs.pkgsCross.aarch64-multiplatform.buildUBoot {
  pname = "uboot-tauchgang-enchilada";
  version = "2026.07-rc1";

  src = pkgs.pkgsCross.aarch64-multiplatform.fetchFromGitLab {
    domain = "gitlab.postmarketos.org";
    owner = "tauchgang";
    repo = "u-boot";
    rev = "1f56592576887ffcae0e7d44c66b5cf030674908";
    hash = "sha256-A6AombRRnUaHkn7Fn7p6tkAEYnA+Z4vaJliRVB0hKuo=";
  };

  defconfig = "qcom_defconfig qcom-phone.config tauchgang.config";
  extraConfig = ''CONFIG_DEFAULT_DEVICE_TREE="qcom/sdm845-oneplus-enchilada"'';

  filesToInstall = [
    "u-boot-nodtb.bin"
    "u-boot.dtb"
  ];

  extraMeta.platforms = [ "aarch64-linux" ];
}).overrideAttrs
  (attrs: {
    nativeBuildInputs = attrs.nativeBuildInputs ++ [
      pkgs.pkgsCross.aarch64-multiplatform.unixtools.xxd
    ];
  })
|> (
  uboot:
  buildPackages.runCommand "${uboot.pname}-boot-image" ''
    mkdir -p $out
    gzip ${uboot}/u-boot-nodtb.bin -c > u-boot-nodtb.bin.gz
    cat u-boot-nodtb.bin.gz ${uboot}/u-boot.dtb > u-boot.bin.gz
    printf "\0" | gzip --stdout > "empty.gz"

    ${lib.getExe' buildPackages.android-tools "mkbootimg"} \
      --base 0x0 \
      --kernel_offset 0x8000 \
      --pagesize 4096 \
      --os_patch_level 2028-09-21 \
      --ramdisk empty.gz \
      --kernel u-boot.bin.gz \
      -o $out/u-boot.img
  ''
)
