{ kernel, ... }:
{
  kernel.hosts.superlab =
    pkgs: armCross:
    (kernel.lib.linux {
      inherit pkgs armCross;
      localVer = "rockchip";
      class = "rockchip";
      host = "superlab";
      structuredExtraConfig = kernel.config.default.superlab;
      isArm = true;
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
      '';
      patches = with kernel.patches.injector pkgs; armbian.rockchip-patches;
    });

  perSystem =
    { pkgs, ... }:
    kernel.lib.package-gen {
      inherit pkgs;
      host = "superlab";
    };
}
