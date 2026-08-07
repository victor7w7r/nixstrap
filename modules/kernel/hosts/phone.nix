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
        (
          "${inputs.vanilla-mobile-nixos.outPath}/pkgs/linux-kernel/sdm845/kernel-patches"
          |> (
            patches:
            [ "${patches}/../config_fixes.patch" ]
            ++ ((import patches) |> map (item: "${patches}/${item.name}.patch"))
          )
        )
        ++ cachyos.std
        ++ tachyon.std
        ++ bunker.std;
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
