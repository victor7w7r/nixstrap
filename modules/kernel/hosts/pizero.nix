{ inputs, kernel, ... }:
{
  perSystem = { pkgs, ... }: kernel.lib.package-gen pkgs "pizero";

  kernel.hosts.pizero =
    pkgs: host:
    (kernel.lib.linux {
      inherit pkgs;
      structuredExtraConfig = kernel.config.default.pizero;
      localVer = "sunxi-hardened";
      host = "pizero";
      defconfig = "sunxi_defconfig";
      isArm = true;
      patches =
        with kernel.patches.injector pkgs;
        sunxi ++ (bunker.lts { isHardened = true; }) ++ (tachyon.lts { isVanilla = true; });
      src =
        kernel.patches.uwe5622 pkgs
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
            dtbMake = "dtb-\$(CONFIG_ARCH_SUNXI) += sun50i-h618-orangepi-zero2w.dtb";
          }
        );
    });
}
