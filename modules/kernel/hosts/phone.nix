{ inputs, kernel, ... }:
{
  perSystem = { pkgs, ... }: kernel.lib.package-gen pkgs "phone" true;

  kernel.hosts.phone =
    pkgs:
    (kernel.lib.linux {
      inherit pkgs;
      structuredExtraConfig = kernel.config.default.phone;
      localVer = "sdm845";
      host = "phone";
      defconfig = "phone_defconfig";
      isArm = true;
      patches =
        with kernel.patches.injector pkgs;
        (qcom { }) ++ (bunker.latest { }) ++ (tachyon.latest { isVanilla = true; });
      src =
        inputs.linux-latest
        |> (
          src:
          kernel.lib.defconfig-clear {
            inherit pkgs src;
            arch = "arm64";
            defconfig = "phone_defconfig";
          }
        )
        |> (
          src:
          kernel.lib.dts-cleaner {
            inherit pkgs src;
            class = "qcom";
            dtbMake = ''
              dtb-\$(CONFIG_ARCH_QCOM) += sdm845-oneplus-enchilada.dtb
              dtb-\$(CONFIG_ARCH_QCOM) += sdm845-oneplus-fajita.dtb
            '';
          }
        );
    });
}
