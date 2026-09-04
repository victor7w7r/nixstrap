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
      src = kernel.lib.kernel-cleaner {
        inherit pkgs;
        src = inputs.linux-latest;
        arch = "arm64";
        defconfig = "phone_defconfig";
        class = "qcom";
        dtbMake = ''
          dtb-\$(CONFIG_ARCH_QCOM) += sdm845-oneplus-enchilada.dtb
          dtb-\$(CONFIG_ARCH_QCOM) += sdm845-oneplus-fajita.dtb
        '';
        config = kernel.patches.qcom-defconfig pkgs;
      };
      patches =
        with kernel.patches.injector pkgs;
        (qcom { })
        ++ cachyos.latest.std
        ++ (tachyon.common { source = inputs.tachyon-patches-latest; })
        ++ (tachyon.latest { })
        ++ (bunker.common { isLts = false; })
        ++ (bunker.latest { });
    });
}
