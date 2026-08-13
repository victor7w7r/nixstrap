{ inputs, kernel, ... }:
{
  perSystem = { pkgs, ... }: kernel.lib.package-gen pkgs "pizero" true;

  kernel.hosts.pizero =
    pkgs:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "sunxi-hardened";
      isArm = true;
      host = "pizero";
      src = inputs.linux-latest-lts;
      /*class = "allwinner";
      dtbMake = ''dtb-\$(CONFIG_ARCH_SUNXI) += sun50i-h618-orangepi-zero2w.dtb'';
      defconfig = "${inputs.armbian}/config/kernel/linux-sunxi64-edge.config";*/
      structuredExtraConfig = kernel.config.default.pizero;
      patches = with kernel.patches.injector pkgs; [ hardened ] ++ armbian.sunxi-patches;
    });
}
