{ kernel, ... }:
{
  flake-file.inputs.uwe5622 = {
    url = "github:Ran-Thegoth/uwe5622";
    flake = false;
  };

  kernel.hosts.pizero =
    pkgs: armCross:
    (kernel.lib.linux {
      inherit pkgs armCross;
      localVer = "sunxi-hardened";
      isArm = true;
      class = "allwinner";
      dtbMake = ''dtb-\$(CONFIG_ARCH_SUNXI) += sun50i-h618-orangepi-zero2w.dtb'';
      patches =
        with kernel.patches.injector pkgs;
        cachyos.hardened ++ tachyon.std ++ bunker.hardened ++ armbian.sunxi-patches;
      structuredExtraConfig = kernel.config.default.pizero;
    })
    |> (generated: {
      pizero-kernelPackages = generated.packages;
      pizero-kernel = generated.kernel;
      pizero-config = generated.config;
    });

  perSystem =
    { pkgs, ... }:
    kernel.lib.package-gen {
      inherit pkgs;
      host = "pizero";
    };
}
