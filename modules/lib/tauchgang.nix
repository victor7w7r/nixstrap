{ inputs, lib, ... }:
{
  imports = [ (inputs.den.namespace "tauchgang" false) ];

  tauchgang.lib.call =
    pkgs: isFajita:
    (pkgs.buildUBoot {
      pname = "uboot-tauchgang-${if isFajita then "fajita" else "enchilada"}";
      version = "2026.07-rc1";
      src = pkgs.fetchFromGitLab {
        domain = "gitlab.postmarketos.org";
        owner = "tauchgang";
        repo = "u-boot";
        rev = "1f56592576887ffcae0e7d44c66b5cf030674908";
        hash = "sha256-A6AombRRnUaHkn7Fn7p6tkAEYnA+Z4vaJliRVB0hKuo=";
      };

      defconfig = "qcom_defconfig qcom-phone.config tauchgang.config";
      extraConfig = ''CONFIG_DEFAULT_DEVICE_TREE="qcom/sdm845-oneplus-${
        if isFajita then "fajita" else "enchilada"
      }"'';

      filesToInstall = [
        "u-boot-nodtb.bin"
        "u-boot.dtb"
      ];

      extraMeta.platforms = [ "aarch64-linux" ];
    }).overrideAttrs
      (attrs: {
        nativeBuildInputs = with pkgs; attrs.nativeBuildInputs ++ [ unixtools.xxd ];
      })
    |> (
      uboot:
      pkgs.stdenvNoCC.mkDerivation {
        name = "uboot-${if isFajita then "fajita" else "enchilada"}";
        buildCommand = ''
          mkdir -p $out
          gzip ${uboot}/u-boot-nodtb.bin -c > u-boot-nodtb.bin.gz
          cat u-boot-nodtb.bin.gz ${uboot}/u-boot.dtb > u-boot.bin.gz
          printf "\0" | gzip --stdout > "empty.gz"

          ${lib.getExe' pkgs.android-tools "mkbootimg"} \
            --base 0x0 \
            --kernel_offset 0x8000 \
            --pagesize 4096 \
            --os_patch_level 2028-09-21 \
            --ramdisk empty.gz \
            --kernel u-boot.bin.gz \
            -o $out/u-boot.img
        '';
      }
    );
}
