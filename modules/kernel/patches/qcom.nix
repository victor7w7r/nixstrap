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
