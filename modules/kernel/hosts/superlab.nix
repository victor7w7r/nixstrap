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
      src = kernel.lib.kernel-cleaner {
        inherit pkgs;
        src = inputs.linux-lts;
        arch = "arm64";
        defconfig = "rockchip_defconfig";
        class = "rockchip";
        dtbMake = ''dtb-\$(CONFIG_ARCH_ROCKCHIP) += rk3588-rock-5b.dtb'';
        config = "${inputs.armbian}/config/kernel/linux-rockchip64-current.config";
      };
      patches =
        with kernel.patches.injector pkgs;
        rockchip
        ++ (cachyos.lts { })
        ++ (tachyon.common { source = inputs.tachyon-patches-lts; })
        ++ (tachyon.lts { })
        ++ (bunker.common { })
        ++ (bunker.lts { })
        ++ [ "${self}/modules/kernel/patches/files/rk3588-domain.patch" ];
    });
}
