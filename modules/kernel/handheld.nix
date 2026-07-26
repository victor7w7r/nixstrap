{ kernel, ... }:
{
  kernel.hosts.handheld =
    pkgs:
    (kernel.lib.v7w7r {
      inherit pkgs;
      localVer = "handheld-native";
      patches =
        with kernel.patches.injector pkgs;
        cachyos.handheld ++ tachyon.gaming ++ bunker.std ++ asus;
      extraConfig = with kernel.config.modules; [
        (cmdline { isAmd = true; })
        default
        freq.high
        hardware.desktop-wserial
        hardware.native
        net
        storage.ntfs
        storage.not-raid
        storage.not-xfs
        vendor.amd
        vendor.not-broadcom
      ];
    })
    |> (generated: {
      handheld-kernelPackages = generated.packages;
      handheld-kernel = generated.kernel;
      handheld-config = generated.config;
    });

  perSystem =
    { lib, pkgs, ... }:
    (kernel.hosts.handheld pkgs)
    |> (src: {
      devShells.handheld-kconfig = kernel.lib.kconfig {
        inherit pkgs;
        kernel = src.handheld-kernel;
      };

      packages = lib.mkAfter {
        handheld-config = src.handheld-config;
        handheld-kernel = src.handheld-kernel;
      };
    });
}
