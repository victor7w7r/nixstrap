{ kernel, inputs, ... }:
{
  kernel.hosts.phone =
    pkgs: armCross:
    (kernel.lib.linux {
      inherit pkgs armCross;
      localVer = "sdm845";
      isArm = true;
      class = "qcom";
      dtbMake = ''
        dtb-\$(CONFIG_ARCH_QCOM) += sdm845-oneplus-enchilada.dtb
        dtb-\$(CONFIG_ARCH_QCOM) += sdm845-oneplus-fajita.dtb
      '';
      patches =
        with kernel.patches.injector pkgs;
        cachyos.std
        ++ tachyon.std
        ++ bunker.std
        ++ (
          "${inputs.vanilla-mobile-nixos.outPath}/pkgs/linux-kernel/sdm845/kernel-patches"
          |> (
            patches:
            [ "${patches}/../config_fixes.patch" ]
            ++ (
              (import patches)
              |> builtins.filter (
                item:
                !builtins.elem item.name [
                  "0107-arm64-dts-qcom-Introduce-support-for-Xiaomi-Mi-Mix-3"
                  "0144-hack-scripts-allow-unused-command-line-arguments-wit"
                  "0148-dt-bindings-arm-qcom-Add-Xiaomi-Poco-F1-Tianma-varia"
                ]
              )
              |> map (item: "${patches}/${item.name}.patch")
            )
          )
        );

      structuredExtraConfig = kernel.config.default.phone;
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
