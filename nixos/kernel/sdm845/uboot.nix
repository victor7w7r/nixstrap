{
  lib,
  pkgs,
  kernel,
  kernelData,
  device ? "fajita",
  ...
}:
let
  majorMinor = lib.versions.majorMinor kernelData.sdm845.version;
  fetch = (pkgs.callPackage ../fetch.nix { inherit kernelData majorMinor; });
  uboot = pkgs.buildUBoot {
    version = "master";
    src = fetchGit {
      url = "https://github.com/u-boot/u-boot.git";
      rev = "92dcb3ad5d98f494b2448a7345e1cb7eefa50278";
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
      CONFIG_CMD_UFETCH=y
      CONFIG_CMD_SELECT_FONT=y
      CONFIG_VIDEO_FONT_8X16=y
    '';
    prePatch = ''
       cat configs/qcom_defconfig board/qualcomm/qcom-phone.config > f
       mv f configs/qcom_defconfig

       rm dts/upstream/src/arm64/qcom/sdm845-oneplus-${
         if device == "fajita" then "enchilada" else "fajita"
       }.dts

      chmod -R +w dts/upstream/src/arm64/qcom/
      chmod -R +w dts/upstream/include/dt-bindings/
      cp -rn ${fetch.sdm845}/include/dt-bindings/* dts/upstream/include/dt-bindings/

       cp -r ${fetch.sdm845}/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi dts/upstream/src/arm64/qcom/sdm845-oneplus-common.dtsi
       cp -r ${fetch.sdm845}/arch/arm64/boot/dts/qcom/sdm845-oneplus-${device}.dts dts/upstream/src/arm64/qcom/sdm845-oneplus-${device}.dts
       cp -r ${fetch.sdm845}/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi dts/upstream/src/arm64/qcom/sdm845-oneplus-common.dtsi
       cp -r ${fetch.sdm845}/arch/arm64/boot/dts/qcom/sdm845.dtsi dts/upstream/src/arm64/qcom/sdm845.dtsi
       cp -r ${fetch.sdm845}/arch/arm64/boot/dts/qcom/sdm845-wcd9340.dtsi dts/upstream/src/arm64/qcom/sdm845-wcd9340.dtsi
       cp -r ${fetch.sdm845}/arch/arm64/boot/dts/qcom/pm8998.dtsi dts/upstream/src/arm64/qcom/pm8998.dtsi
       cp -r ${fetch.sdm845}/arch/arm64/boot/dts/qcom/pmi8998.dtsi dts/upstream/src/arm64/qcom/pmi8998.dtsi

       cp -r ${fetch.sdm845}/include/dt-bindings/* dts/upstream/include/dt-bindings/*
    '';
    extraMakeFlags = [ "DEVICE_TREE=qcom/sdm845-oneplus-${device}" ];
    defconfig = "qcom_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    filesToInstall = [
      "u-boot*"
      "dts/upstream/src/arm64/qcom/sdm845-oneplus-${device}.dtb"
    ];
  };
in
pkgs.runCommand "sdm845-oneplus-bootimg"
  {
    nativeBuildInputs = with pkgs; [
      android-tools
    ];
  }
  ''
    cp ${uboot}/u-boot-nodtb.bin ./u-boot-nodtb.bin
    cp ${uboot}/sdm845-oneplus-${device}.dtb ./sdm845-oneplus-${device}.dtb
    cp -r ${kernel} ./kernel
    gzip ./u-boot-nodtb.bin
    mkbootimg \
      --header_version 2 \
      --kernel ./u-boot-nodtb.bin.gz \
      --dtb ./sdm845-oneplus-${device}.dtb \
      --base "0x00000000" \
      --kernel_offset "0x00008000" \
      --ramdisk_offset "0x01000000" \
      --second_offset "0x00000000" \
      --tags_offset "0x00000100" \
      --pagesize 4096 \
      -o $out
  ''
