{ kernel, ... }:
{
  kernel.hosts.superlab =
    pkgs: armCross:
    (kernel.lib.linux {
      inherit pkgs armCross;
      localVer = "rockchip";
      class = "rockchip";
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
      patches =
        with kernel.patches.injector pkgs;
        cachyos.std ++ tachyon.std bunker.std ++ armbian.rockchip-patches;
      structuredExtraConfig = kernel.config.default.superlab-phone;
    })
    |> (generated: {
      superlab-config = generated.config;
      superlab-kernelPackages = generated.packages;
      superlab-kernel = generated.kernel;
    });

  perSystem =
    { pkgs, ... }:
    kernel.lib.package-gen {
      inherit pkgs;
      host = "superlab";
    };
}
