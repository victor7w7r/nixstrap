{ kernel, ... }:
{
  kernel.hosts.generic =
    pkgs:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "v2";
      patches = with kernel.patches.injector pkgs; cachyos.std ++ tachyon.std ++ bunker.std;
      extraConfig = with kernel.config.modules; [
        (cmdline { })
        default
        freq.high
        hardware.desktop
        hardware.generic
        hardware.serial
        net
        storage.not-raid
        storage.xfs
        vendor.not-vendor
        vendor.not-broadcom
      ];
    })
    |> (generated: {
      generic-kernelPackages = generated.packages;
      generic-kernel = generated.kernel;
      generic-config = generated.config;
    });

  perSystem =
    { lib, pkgs, ... }:
    (kernel.hosts.generic pkgs)
    |> (src: {
      devShells.generic-kconfig = kernel.lib.kconfig {
        inherit pkgs;
        kernel = src.generic-kernel;
      };
      packages = lib.mkAfter {
        generic-config = src.generic-config;
        generic-kernel = src.generic-kernel;
      };
    });
}
