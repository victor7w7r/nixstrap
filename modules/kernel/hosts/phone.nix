{ inputs, kernel, ... }:
{
  perSystem =
    { pkgs, ... }: kernel.lib.package-gen pkgs "phone" "aarch64-linux" pkgs.stdenv.hostPlatform.system;

  kernel.hosts.phone =
    pkgs: host: arch: system:
    (kernel.lib.linux {
      inherit
        pkgs
        host
        arch
        system
        ;
      structuredExtraConfig = kernel.config.default.phone;
      localVer = "sdm845";
      defconfig = "phone_defconfig";
      patches = with kernel.patches.injector pkgs; (qcom { }) ++ (bunker.latest { }) ++ (tachyon.latest { isVanilla = true; });
      src =
        inputs.linux-latest
        |> (
          src:
          kernel.lib.defconfig-clear {
            inherit pkgs src;
            arch = "arm64";
            config = kernel.patches.qcom-defconfig pkgs;
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
