{ kernel, inputs, ... }:
{
  kernel.hosts.phone =
    pkgs: armCross:
    (kernel.lib.linux {
      inherit pkgs armCross;
      localVer = "sdm845";
      isArm = true;
      patches =
        "${inputs.vanilla-mobile-nixos.outPath}/pkgs/linux-kernel/sdm845/kernel-patches"
        |> (
          patches:
          with kernel.patches.injector pkgs;
          [ "${patches}/../config_fixes.patch" ]
          ++ (
            (import patches)
            |> builtins.filter (
              item:
              !builtins.elem item.name [
                /*
                  "0001-arm64-dts-qcom-sdm845-xiaomi-beryllium-Enable-ath10k"
                  "0017-arm64-dts-qcom-sdm845-xiaomi-beryllium-Add-haptics-s"
                  "0024-arm64-dts-qcom-sdm845-xiaomi-beryllium-Enable-fuel-g"
                  "0042-hack-ASoC-dt-bindings-qcom-q6dsp-add-internal-mi2s-s"
                */
              ]
            )
            |> map (item: "${patches}/${item.name}.patch")
          )
        );
      extraConfig = with kernel.config.modules; [ qcom ];
    })
    |> (generated: {
      phone-config = generated.config;
      phone-kernelPackages = generated.packages;
      phone-kernel = generated.kernel;
    });

  perSystem =
    { pkgs, ... }:
    kernel.lib.package-gen {
      inherit pkgs;
      host = "phone";
    };
}
