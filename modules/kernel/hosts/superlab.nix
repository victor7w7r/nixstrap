{
  inputs,
  kernel,
  self,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    kernel.lib.package-gen pkgs "superlab" "aarch64-linux" pkgs.stdenv.hostPlatform.system;

  kernel.hosts.superlab =
    pkgs: host: arch: system:
    (kernel.lib.linux {
      inherit
        pkgs
        host
        arch
        system
        ;
      structuredExtraConfig = kernel.config.default.superlab;
      localVer = "rockchip";
      defconfig = "rockchip_defconfig";
      legacy = true;
      patches =
        with kernel.patches.injector pkgs;
        (kernel.patches.armbian.rockchip { }) ++ (bunker.lts { }) ++ (tachyon.lts { isVanilla = true; });
      src =
        inputs.linux-lts
        |> (
          src:
          kernel.lib.defconfig-clear {
            inherit pkgs src;
            arch = "arm64";
            config = "${inputs.armbian}/config/kernel/linux-rockchip64-current.config";
            defconfig = "rockchip_defconfig";
          }
        )
        |> (
          src:
          kernel.lib.dts-cleaner {
            inherit pkgs src;
            class = "rockchip";
            dtbMake = ''dtb-\$(CONFIG_ARCH_ROCKCHIP) += rk3588-rock-5b.dtb'';
            overlays = "${inputs.armbian}/patch/kernel/archive/rockchip64-6.18/overlay";
            overlayMake = ''
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-fanctrl.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-sata0.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-sata1.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-sata2.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-hdmirx.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-can0-m0.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-can0-m1.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-can1-m0.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-can1-m1.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-can2-m0.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-can2-m1.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-i2c8-m2.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm0-m0.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm0-m1.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm0-m2.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm1-m0.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm1-m1.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm1-m2.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm2-m1.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm3-m0.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm3-m1.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm3-m2.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm3-m3.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm5-m2.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm6-m0.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm6-m2.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm7-m0.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm7-m3.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm8-m0.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm10-m0.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm11-m0.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm11-m1.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm12-m0.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm13-m0.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm13-m2.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm14-m0.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm14-m1.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm14-m2.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm15-m0.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm15-m1.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm15-m2.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-pwm15-m3.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-uart1-m1.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-uart3-m1.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-uart4-m2.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-uart6-m1.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-uart7-m2.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-uart8-m1.dtbo
              dtbo-\$(CONFIG_ARCH_ROCKCHIP) += rockchip-rk3588-rkvenc-overlay.dtbo
            '';
          }
        );
    });

}
