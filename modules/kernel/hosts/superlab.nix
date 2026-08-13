{ inputs, kernel, ... }:
{
  perSystem = { pkgs, ... }: kernel.lib.package-gen pkgs "superlab" true;

  kernel.hosts.superlab =
    pkgs:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "rockchip";
      host = "superlab";
      structuredExtraConfig = kernel.config.default.superlab;
      isArm = true;
      src = inputs.linux-rockchip;
     /* class = "rockchip";
      defconfig = "${inputs.armbian}/config/kernel/linux-rockchip64-edge.config";
      dtbMake = ''
        dtb-\$(CONFIG_ARCH_ROCKCHIP) += rk3588-rock-5b.dtb
        dtb-\$(CONFIG_ARCH_ROCKCHIP) += rk3588-rock-5b-pcie-ep.dtbo
        dtb-\$(CONFIG_ARCH_ROCKCHIP) += rk3588-rock-5b-pcie-srns.dtbo
        dtb-\$(CONFIG_ARCH_ROCKCHIP) += rk3588-rock-5b-plus.dtb
        dtb-\$(CONFIG_ARCH_ROCKCHIP) += rk3588-rock-5b-pcie-ep.dtb
        rk3588-rock-5b-pcie-ep-dtbs := rk3588-rock-5b.dtb \
         rk3588-rock-5b-pcie-ep.dtbo
        dtb-\$(CONFIG_ARCH_ROCKCHIP) += rk3588-rock-5b-pcie-srns.dtb
        rk3588-rock-5b-pcie-srns-dtbs := rk3588-rock-5b.dtb \
         rk3588-rock-5b-pcie-srns.dtbo
         '';*/
      patches = with kernel.patches.injector pkgs; armbian.rockchip-patches;
    });

}
