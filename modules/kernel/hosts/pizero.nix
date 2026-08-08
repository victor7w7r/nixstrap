{ kernel, ... }:
{
  kernel.hosts.pizero =
    pkgs: armCross:
    (kernel.lib.linux {
      inherit pkgs armCross;
      localVer = "sunxi-hardened";
      isArm = true;
      host = "pizero";
      class = "allwinner";
      dtbMake = ''dtb-\$(CONFIG_ARCH_SUNXI) += sun50i-h618-orangepi-zero2w.dtb'';
      structuredExtraConfig = kernel.config.default.pizero;
      patches =
        with kernel.patches.injector pkgs;
        cachyos.hardened ++ bunker.hardened ++ armbian.sunxi-patches;
    });

  perSystem =
    { pkgs, ... }:
    kernel.lib.package-gen {
      inherit pkgs;
      host = "pizero";
    };
}
