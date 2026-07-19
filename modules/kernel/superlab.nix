{ inputs, kernel, ... }:
{
  kernel.hosts.superlab =
    pkgs:
    (kernel.lib.v7w7r {
      inherit pkgs;
      localVer = "rockchip";
      src = inputs.cachyos-linux;
      version = (kernel.linux.injector pkgs).version.string;
      config = "${(kernel.patches.injector pkgs).armbian.source}/config/kernel/linux-rockchip64-current.config";
      patches =
        with kernel.patches.injector pkgs;
        cachyos.std ++ tachyon.std ++ bunker.srd ++ armbian.rockchip-patches;
      extraConfig = with kernel.config.modules; [
        (cmdline { })
        default
        freq.high
        hardware.not-phone
        net
        storage.not-cdrom
        storage.f2fs
        storage.ntfs
        storage.not-raid
        storage.not-xfs
        vendor.not-vendor
        vendor.not-broadcom
      ];
    })
    |> (generated: {
      superlab-config = generated.config;
      superlab-kernelPackages = generated.packages;
      superlab-kernel = generated.kernel;
    });
}
