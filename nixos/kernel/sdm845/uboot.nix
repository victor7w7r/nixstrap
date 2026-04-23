{
  lib,
  pkgs,
  kernelData,
  device ? "fajita",
  ...
}:
let
  majorMinor = lib.versions.majorMinor kernelData.sdm845.version;
  fetch = (pkgs.callPackage ../fetch.nix { inherit kernelData majorMinor; });
  uboot = pkgs.buildUBoot {
    extraMakeFlags = [ "DEVICE_TREE=qcom/sdm845-oneplus-${device}" ];
    defconfig = "qcom_defconfig phone.config";
    version = "master";
    extraMeta.platforms = [ "aarch64-linux" ];
    src = fetchGit {
      url = "https://git.codelinaro.org/clo/qcomlt/u-boot.git";
      rev = "6fc40f2499b1a517487933d7d81a482f6dce7751";
    };
    nativeBuildInputs = with pkgs; [
      xxd
      bison
      flex
      openssl
      gnutls
      android-tools
    ];
    extraConfig = ''
      CONFIG_CMD_HASH=y
      CONFIG_CMD_BLKMAP=y
      CONFIG_BLKMAP=y
      CONFIG_CMD_UFETCH=y
      CONFIG_CMD_SELECT_FONT=y
      CONFIG_VIDEO_FONT_16X32=y
      CONFIG_BOOTDELAY=5
    '';
    filesToInstall = [
      "u-boot*"
      "dts/upstream/src/arm64/qcom/sdm845-oneplus-${device}.dtb"
    ];
    prePatch = ''
      #cat configs/qcom_defconfig board/qualcomm/qcom-phone.config > f
      #mv f configs/qcom_defconfig

      #rm dts/upstream/src/arm64/qcom/sdm845-oneplus-enchilada.dts
      #rm dts/upstream/src/arm64/qcom/sdm845-oneplus-fajita.dts

      cp ${./qcom-phone.env} board/qualcomm/qcom-phone.env
      cp ${./qcom-phone.config} board/qualcomm/qcom-phone.config

      #cp -r ${./common.dtsi} dts/upstream/src/arm64/qcom/sdm845-oneplus-common.dtsi
      #cp -r ${./${device}.dts} dts/upstream/src/arm64/qcom/sdm845-oneplus-${device}.dts
      #cp -r ${./common.dtsi} dts/upstream/src/arm64/qcom/sdm845-oneplus-common.dtsi

      #cp -r ${fetch.sdm845}/include/dt-bindings/input/qcom,spmi-haptics.h dts/upstream/include/dt-bindings/input
      #cp -r ${fetch.sdm845}/include/dt-bindings/sound/qcom,q6voice.h dts/upstream/include/dt-bindings/sound
      #cp -r ${fetch.sdm845}/include/uapi/linux/input-event-codes.h dts/upstream/include/dt-bindings/input/linux-event-codes.h
      #chmod -R +w dts/upstream/src/arm64/
    '';
  };
in
pkgs.stdenvNoCC.mkDerivation {
  name = "sdm845-oneplus-bootimg";
  dontBuild = true;
  dontFixup = true;
  src = uboot;
  nativeBuildInputs = with pkgs; [
    android-tools
    mkbootimg
    gzip
  ];
  installPhase = ''
    gzip u-boot-nodtb.bin
    cat u-boot.dtb >> u-boot-nodtb.bin.gz
    mkbootimg \
      --base 0x0 \
      --kernel_offset 0x8000 \
      --ramdisk_offset 0x01000000 \
      --tags_offset 0x100 \
      --pagesize 4096 \
      --kernel u-boot-nodtb.bin.gz \
      -o "$out"
  '';
}
