{ inputs, kernel, ... }:
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
      src = kernel.lib.kernel-cleaner {
        inherit pkgs;
        src = inputs.linux-latest;
        arch = "arm64";
        defconfig = "rockchip_defconfig";
        class = "rockchip";
        dtbMake = ''dtb-\$(CONFIG_ARCH_ROCKCHIP) += rk3588-rock-5b.dtb'';
        config = "${inputs.armbian}/config/kernel/linux-rockchip64-edge.config";
      };
      patches =
        with kernel.patches.injector pkgs;
        rockchip
        ++ cachyos.latest.std
        ++ (tachyon.common { source = inputs.tachyon-patches-latest; })
        ++ (tachyon.latest { })
        ++ (bunker.common { isLts = false; })
        ++ (bunker.latest { });
    });
}
