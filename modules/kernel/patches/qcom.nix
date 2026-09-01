{ inputs, ... }:
{
  flake-file.inputs = {
    sdm845-config = {
      url = "https://gitlab.com/sdm845-mainline/linux/-/raw/sdm845-7.1-rc1-r0/arch/arm64/configs/sdm845.config?ref_type=tags";
      flake = false;
    };
    sdm845-misc = {
      url = "https://gitlab.com/sdm845-mainline/linux/-/raw/sdm845-7.1-rc1-r0/arch/arm64/configs/misc.config?ref_type=tags";
      flake = false;
    };
    sdm845-defconfig = {
      url = "https://gitlab.com/sdm845-mainline/linux/-/raw/sdm845-7.1-rc1-r0/arch/arm64/configs/defconfig?ref_type=tags";
      flake = false;
    };
  };

  kernel.patches = {
    qcom =
      { }:
      "${inputs.vanilla-mobile-nixos.outPath}/pkgs/linux-kernel/sdm845/kernel-patches"
      |> (
        patches:
        [ "${patches}/../config_fixes.patch" ]
        ++ (
          (import patches)
          /*
            |> builtins.filter (
            item:
            !builtins.elem item.name [
              "0017-arm64-dts-qcom-sdm845-xiaomi-beryllium-Add-haptics-s"
              "0024-arm64-dts-qcom-sdm845-xiaomi-beryllium-Enable-fuel-g"
              "0025-arm64-dts-qcom-sdm845-shift-axolotl-Enable-fuel-gaug"
              "0026-arm64-dts-qcom-sdm660-xiaomi-lavender-Enable-support"
              "0027-arm64-dts-qcom-sdm670-google-sargo-Enable-fuel-gauge"
              "0059-hack-arm64-dts-xiaomi-beryllium-common-Add-nodes-for"
              "0061-hack-arm64-dts-qcom-sdm845-shift-axolotl-add-nodes-f"
              "0063-stalled-arm64-dts-qcom-sdm845-xiaomi-beryllium-add-s"
              "0066-arm64-dts-qcom-sdm845-shift-axolotl-Enable-sound-sub"
              "0067-stalled-arm64-qcom-sdm845-shift-axolotl-Improve-audi"
              "0079-arm64-dts-qcom-sdm845-shift-axolotl-Introduce-camera"
              "0080-arm64-dts-qcom-sdm845-xiaomi-beryllium-add-support-f"
              "0082-stalled-arm64-dts-qcom-sdm845-shift-axolotl-Add-q6vo"
              "0083-stalled-arm64-dts-qcom-sdm845-xiaomi-beryllium-Add-q"
              "0087-arm64-dts-qcom-sdm845-shift-axolotl-Correct-touchscr"
              "0088-arm64-dts-qcom-sdm845-shift-axolotl-Enable-NFC"
              "0089-arm64-dts-qcom-sdm845-google-common-Enable-NFC"
              "0107-arm64-dts-qcom-Introduce-support-for-Xiaomi-Mi-Mix-3"
              "0115-arm64-dts-qcom-sdm845-xiaomi-beryllium-Introduce-fra"
              "0117-arm64-dts-qcom-sdm845-shift-axolotl-Convert-fb-to-us"
              "0118-arm64-dts-qcom-sdm845-samsung-starqltechn-Convert-fb"
              "0119-arm64-dts-qcom-sdm845-xiaomi-beryllium-tianma-Disabl"
              "0120-arm64-dts-qcom-sdm845-google-Enable-fuel-gauge"
              "0133-arm64-dts-qcom-sdm845-google-Add-STM-FTS-touchscreen"
              "0141-arm64-dts-qcom-sdm845-shift-axolotl-describe-WiFi-BT"
              "0147-Correct-Xiaomi-Poco-F1-compatible-strings-and-evalua"
              "0148-dt-bindings-arm-qcom-Add-Xiaomi-Poco-F1-Tianma-varia"
              "0162-arm64-dts-qcom-sdm845-shift-axolotl-Add-actuator-for"
              "0163-HACK-arm64-dts-qcom-xiaomi-beryllium-enable-serial-d"
              "0164-arm64-dts-qcom-sdm845-xiaomi-beryllium-common-update"
              "0168-arm64-dts-qcom-sdm845-xiaomi-beryllium-common-add-su"
              "0170-Revert-arm64-dts-qcom-sdm845-xiaomi-beryllium-tianma"
              "0174-arm64-dts-qcom-sdm845-xiaomi-beryllium-add-rear-came"
              "0178-arm64-dts-qcom-sdm845-starqltechn-improve-support"
              "0179-arm64-dts-qcom-sdm845-starqltechn-fix-slpi-support"
              "0183-arm64-dts-qcom-sdm845-google-common-add-audio-suppor"
              "0184-arm64-dts-qcom-sdm845-google-common-fix-camera-clock"
              "0185-arm64-dts-qcom-sdm845-lg-common-Add-camera-flash"
              "0186-arm64-dts-qcom-sdm845-lg-common-Change-ipa-gsi-loade"
              "0187-arm64-dts-qcom-sdm845-lg-judyln-judyp-Reference-memo"
              "0188-arm64-dts-qcom-sdm845-lg-Enable-qcom-snoc-host-cap-s"
              "0190-input-touchscreen-sw49410-ts-spi-Add-driver-for-SW49"
              "0191-arm64-dts-qcom-sdm845-lg-judyln-add-fuel-gauge"
              "0192-arm64-dts-qcom-sdm845-lg-common-Enable-NFC"
              "0193-sdm845.config-Drivers-for-LG-G7-ThinQ"
            ]
            )
          */
          |> map (item: "${patches}/${item.name}.patch")
        )
      );
    qcom-defconfig =
      pkgs:
      (pkgs.runCommand "qcom-defconfig" { } ''
        cp ${inputs.sdm845-defconfig} defconfig
        cp ${inputs.sdm845-config} sdm845.config
        cp ${inputs.sdm845-misc} misc.config
        cat defconfig sdm845.config misc.config > $out
      '');
  };
}
