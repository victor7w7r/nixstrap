{
  inputs,
  kernel,
  self,
  ...
}:
{
  perSystem =
    { pkgs, ... }: kernel.lib.package-gen pkgs "pizero" "aarch64-linux" pkgs.stdenv.hostPlatform.system;

  kernel.hosts.pizero =
    pkgs: host: arch: system:
    (kernel.lib.linux {
      inherit
        pkgs
        host
        arch
        system
        ;
      structuredExtraConfig = kernel.config.default.pizero;
      localVer = "sunxi-hardened";
      defconfig = "sunxi_defconfig";
      patches =
        with kernel.patches.injector pkgs;
        sunxi
        ++ (bunker.lts { isHardened = true; })
        ++ (tachyon.lts { isVanilla = true; })
        ++ [ "${self}/modules/kernel/patches/fix-opi-zero2w-supplies.patch" ];
      src =
        kernel.patches.armbian.uwe5622 pkgs
        |> (
          src:
          kernel.lib.defconfig-clear {
            inherit pkgs src;
            arch = "arm64";
            config = "${inputs.armbian}/config/kernel/linux-sunxi64-current.config";
            defconfig = "sunxi_defconfig";
          }
        )
        |> (
          src:
          kernel.lib.dts-cleaner {
            inherit pkgs src;
            class = "allwinner";
            dtbMake = ''dtb-\$(CONFIG_ARCH_SUNXI) += sun50i-h618-orangepi-zero2w.dtb'';
            overlays = "${inputs.armbian}/patch/kernel/archive/sunxi-6.18/overlay_64";
            overlayMake = ''
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-gpu.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-i2c0-pi.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-i2c1-pi.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-i2c2-pi.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-i2c2-ph.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-i2c3-pg.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-i2c3-ph.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-i2c4-pg.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-i2c4-ph.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-keys.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-pwm1-ph3.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-pwm1-pi11.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-pwm2-ph2.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-pwm2-pi12.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-pwm3-ph0.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-pwm3-pi13.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-pwm4-ph1.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-pwm4-pi14.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-uart2-pg.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-uart2-pg-rts-cts.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-uart2-ph.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-uart2-ph-rts-cts.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-uart2-pi.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-uart2-pi-rts-cts.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-uart3-pi.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-uart3-pi-rts-cts.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-uart4-pi.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-uart4-pi-rts-cts.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-uart5.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-spi-spidev.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-spidev0_0.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-spidev1_0.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-spidev1_1.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-spidev1_2.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-ir.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-tft35_spi.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-mcp2515.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-ws2812.dtbo
              dtbo-\$(CONFIG_ARCH_SUNXI) += sun50i-h616-light.dtbo
            '';
          }
        );
    });
}
