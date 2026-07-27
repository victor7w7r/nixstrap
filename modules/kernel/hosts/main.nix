{ kernel, ... }:
{
  kernel.hosts.main =
    pkgs:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "native";
      patches = with kernel.patches.injector pkgs; cachyos.std ++ tachyon.std ++ bunker.std;
      extraConfig = with kernel.config.modules; [
        (cmdline {
          isIntel = true;
          isSata = true;
          extra = "video=DP-3:1600x900@60";
        })
        default
        freq.high
        hardware.desktop
        hardware.native
        hardware.serial
        net
        storage.ntfs
        storage.raid
        storage.xfs
        vendor.intel
      ];
    })
    |> (generated: {
      main-kernelPackages = generated.packages;
      main-kernel = generated.kernel;
      main-config = generated.config;
    });

  perSystem =
    { lib, pkgs, ... }:
    (kernel.hosts.main pkgs)
    |> (src: {
      devShells.main-kconfig = kernel.lib.kconfig {
        inherit pkgs;
        kernel = src.main-kernel;
      };
      packages = lib.mkAfter {
        main-config = src.main-config;
        main-kernel = src.main-kernel;
      };
    });
}
