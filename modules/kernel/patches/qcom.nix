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
          |> builtins.filter (
            item:
            !builtins.elem item.name [
              "0001-arm64-dts-qcom-sdm845-xiaomi-beryllium-Enable-ath10k"
              "0027-arm64-dts-qcom-sdm670-google-sargo-Enable-fuel-gauge"
              "0079-arm64-dts-qcom-sdm845-shift-axolotl-Introduce-camera"
              "0088-arm64-dts-qcom-sdm845-shift-axolotl-Enable-NFC"
              "0089-arm64-dts-qcom-sdm845-google-common-Enable-NFC"
              "0092-Input-synaptics-rmi4-handle-duplicate-unknown-PDT-en"
              "0093-Input-synaptics-rmi4-f12-use-hardcoded-values-for-af"
              "0097-Input-synaptics-rmi4-support-fallback-values-for-PDT"
              "0107-arm64-dts-qcom-Introduce-support-for-Xiaomi-Mi-Mix-3"
              "0115-arm64-dts-qcom-sdm845-xiaomi-beryllium-Introduce-fra"
              "0117-arm64-dts-qcom-sdm845-shift-axolotl-Convert-fb-to-us"
              "0118-arm64-dts-qcom-sdm845-samsung-starqltechn-Convert-fb"
              "0123-Input-stmfts-Fix-the-MODULE_LICENSE-string"
              "0124-Input-stmfts-Use-dev-struct-directly"
              "0125-Input-stmfts-Switch-to-devm_regulator_bulk_get_const"
              "0126-Input-stmfts-abstract-reading-information-from-the-f"
              "0127-Input-stmfts-disable-regulators-when-power-on-fails"
              "0128-Input-stmfts-use-client-to-make-future-code-cleaner"
              "0129-dt-bindings-input-touchscreen-st-stmfts-Introduce-re"
              "0130-Input-stmfts-add-optional-reset-GPIO-support"
              "0132-Input-stmfts-support-FTS5"
              "0141-arm64-dts-qcom-sdm845-shift-axolotl-describe-WiFi-BT"
              "0148-dt-bindings-arm-qcom-Add-Xiaomi-Poco-F1-Tianma-varia"
              "0149-arm64-dts-qcom-sdm845-xiaomi-beryllium-Fix-compatibl"
              "0153-media-qcom-camss-Prepare-CSID-for-C-PHY-support"
              "0154-media-qcom-camss-Initialize-lanes-after-lane-configu"
              "0155-media-qcom-camss-csiphy-3ph-Add-Gen2-v1.1-MIPI-CSI-2"
              "0156-media-qcom-camss-csiphy-3ph-Add-Gen2-v1.2.1-MIPI-CSI"
            ]
          )
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
