{ inputs, kernel, ... }:
{
  perSystem = { pkgs, ... }: kernel.lib.package-gen pkgs "superlab";

  kernel.hosts.superlab =
    pkgs: host:
    (kernel.lib.linux {
      inherit pkgs;
      structuredExtraConfig = kernel.config.default.superlab;
      localVer = "rockchip";
      host = "superlab";
      defconfig = "rockchip_defconfig";
      legacy = true;
      isArm = true;
      patches = with kernel.patches.injector pkgs; (rockchip { }) ++ cachyos.legacy ++ tachyon.legacy;
      src =
        (kernel.patches.rk3588 pkgs)
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
            dtbMake = ''dtb-\$(CONFIG_ARCH_ROCKCHIP) += rk3588-rock-5b.dtb'';
          }
        );
    });

}
