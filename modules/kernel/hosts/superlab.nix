{ inputs, kernel, ... }:
{
  perSystem = { pkgs, ... }: kernel.lib.package-gen pkgs "superlab" true;

  kernel.hosts.superlab =
    pkgs:
    (kernel.lib.linux {
      inherit pkgs;
      structuredExtraConfig = kernel.config.default.superlab;
      localVer = "rockchip";
      host = "superlab";
      defconfig = "rockchip_defconfig";
      isArm = true;
      patches = with kernel.patches.injector pkgs;
        (rockchip { }) ++ cachyos.legacy ++ tachyon.legacy;
      src =
        inputs.linux-rockchip
        |> (
          src:
          kernel.lib.defconfig-clear {
            inherit pkgs src;
            arch = "arm64";
            config = "${inputs.armbian}/config/kernel/linux-rk35xx-vendor.config";
            defconfig = "rockchip_defconfig";
          }
        )
        |> (
          src:
          kernel.lib.dts-cleaner {
            inherit pkgs src;
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
          }
        );
    });

}
