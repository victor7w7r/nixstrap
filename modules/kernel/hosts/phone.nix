{ inputs, kernel, ... }:
{
  perSystem = { pkgs, ... }: kernel.lib.package-gen pkgs "phone" true;

  kernel.hosts.phone =
    pkgs:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "sdm845";
      isArm = true;
      /*class = "qcom";
      dtbMake = ''
        dtb-\$(CONFIG_ARCH_QCOM) += sdm845-oneplus-enchilada.dtb
        dtb-\$(CONFIG_ARCH_QCOM) += sdm845-oneplus-fajita.dtb
        '';*/
      host = "phone";
      src = inputs.linux-latest;
      structuredExtraConfig = kernel.config.default.phone;
      #patches =
    });
}
