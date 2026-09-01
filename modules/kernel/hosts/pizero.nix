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
        ++ (cachyos.lts { isHardened = true; })
        ++ (tachyon.common { source = inputs.tachyon-patches-lts; })
        ++ (tachyon.lts { })
        ++ (bunker.common { })
        ++ (bunker.lts { })
        ++ (bunker.hardening { })
        ++ [ "${self}/modules/kernel/patches/files/fix-opi-zero2w-supplies.patch" ];
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
          }
        );
    });
}
