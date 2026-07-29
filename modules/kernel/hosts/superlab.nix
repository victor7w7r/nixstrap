{ kernel, ... }:
{
  kernel.hosts.superlab =
    pkgs:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "rockchip";
      isArm = true;
      notDenial = true;
      isCachyos = false;
      dts = "rockchip/rk3588-rock-5b.dtb";
      patches =
        with kernel.patches.injector pkgs;
        #cachyos.std ++ tachyon.std ++ bunker.std ++
        armbian.rockchip-patches;
      extraConfig = with kernel.config.modules; [
        (cmdline { })
        /*
          default
          freq.high
          hardware.not-phone
          net
          storage.not-cdrom
          storage.f2fs
          storage.ntfs
          storage.not-raid
          storage.not-xfs
          vendor.not-vendor
          vendor.not-broadcom
          {
            USB_GADGET = "n";
            USB_EHCI_TEGRA = "n";
            }
        */
      ];
    })
    |> (generated: {
      superlab-config = generated.config;
      superlab-kernelPackages = generated.packages;
      superlab-kernel = generated.kernel;
    });

  perSystem =
    { lib, pkgs, ... }:
    (kernel.hosts.superlab pkgs)
    |> (src: {
      devShells.superlab-kconfig = kernel.lib.kconfig {
        inherit pkgs;
        kernel = src.superlab-kernel;
      };
      packages = lib.mkAfter {
        superlab-config = src.superlab-config;
        superlab-kernel = src.superlab-kernel;
      };
    });
}
