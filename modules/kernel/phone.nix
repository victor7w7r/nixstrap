{ kernel, ... }:
{
  kernel.hosts.phone =
    pkgs:
    (kernel.lib.v7w7r {
      inherit pkgs;
      localVer = "sdm845";
      isArm = true;
      isCachyos = false;
      patches =
        with kernel.patches.injector pkgs;
        map (item: "./${item.name}.patch") (
          import "${inputs.vanilla-mobile-nixos.outPath}/pkgs/linux-kernel/sdm845/kernel-patches"
        );
      extraConfig = with kernel.config.modules; [ ];
    })
    |> (generated: {
      phone-config = generated.config;
      phone-kernelPackages = generated.packages;
      phone-kernel = generated.kernel;
    });

  perSystem =
    { lib, pkgs, ... }:
    (kernel.hosts.phone pkgs)
    |> (src: {
      devShells.phone-kconfig = kernel.lib.kconfig {
        inherit pkgs;
        kernel = src.phone-kernel;
      };

      packages = lib.mkAfter {
        phone-config = src.phone-config;
        phone-kernel = src.phone-kernel;
      };
    });
}
