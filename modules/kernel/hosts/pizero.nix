{ kernel, ... }:
{
  flake-file.inputs.uwe5622 = {
    url = "github:Ran-Thegoth/uwe5622";
    flake = false;
  };

  kernel.hosts.pizero =
    pkgs:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "sunxi-hardened";
      isArm = true;
      isHardened = true;
      notDenial = true;
      class = "allwinner";
      dtbMake = ''dtb-\$(CONFIG_ARCH_SUNXI) += sun50i-h618-orangepi-zero2w.dtb'';
      patches =
        with kernel.patches.injector pkgs;
        #cachyos.hardened ++ tachyon.std ++ bunker.hardened ++
        armbian.sunxi-patches;
      extraConfig = with kernel.config.modules; [
        (cmdline { })
        /*
          default
          freq.low
          hardware.not-phone
          net
          storage.not-cdrom
          storage.f2fs
          storage.not-ntfs
          storage.not-raid
          storage.xfs
          vendor.not-vendor
          vendor.not-broadcom
          {
            ARCH_MXC = "n";
            ARCH_RENESAS = "n";
            ARCH_SOPHGO = "n";
            AXP20X_POWER = "y";
            FB_SUN5I_EINK = "n";
            AHCI_SUNXI = "y";
            DRM_SUN4I = "y";
            DRM_SUN8I_MIXER = "y";
            DRM_SUN8I_TCON_TOP = "y";
            DMA_SUN6I = "y";
            MDIO_SUN4I = "y";
            MFD_SUN6I_PRCM = "y";
            PWM_SUN4I = "y";
            PHY_SUN9I_USB = "y";
            PHY_SUN50I_USB3 = "y";
            REGULATOR_AXP20X = "y";
            SPI_SUN4I = "y";
            SERIO_SUN4I_PS2 = "y";
            STMMAC_ETH = "y";
            SUN50I_H6_PRCM_PPU = "y";
            USB_MUSB_SUNXI = "y";
            }
        */
      ];
    })
    |> (generated: {
      pizero-kernelPackages = generated.packages;
      pizero-kernel = generated.kernel;
      pizero-config = generated.config;
    });

  perSystem =
    { lib, pkgs, ... }:
    (kernel.hosts.pizero pkgs)
    |> (src: {
      devShells.pizero-kconfig = kernel.lib.kconfig {
        inherit pkgs;
        kernel = src.pizero-kernel;
      };
      packages = lib.mkAfter {
        pizero-config = src.pizero-config;
        pizero-kernel = src.pizero-kernel;
      };
    });
}
