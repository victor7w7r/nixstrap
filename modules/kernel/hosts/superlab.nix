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
      patches =
        with kernel.patches.injector pkgs;
        (kernel.patches.armbian.legacy-rockchip { }) ++ cachyos.legacy ++ tachyon.legacy;
      #++ (bunker.lts { })
      # ++ (tachyon.lts { isVanilla = true; })
      #++ [ "${self}/modules/kernel/patches/rk3588-domain.patch" ];
      src =
        #inputs.linux-lts
        (kernel.patches.armbian.legacy-rk3588 pkgs)
        |> (
          src:
          kernel.lib.defconfig-clear {
            inherit pkgs src;
            arch = "arm64";
            config = "${inputs.armbian}/config/kernel/linux-rk35xx-vendor.config";
            #config = "${inputs.armbian}/config/kernel/linux-rockchip64-current.config";
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
