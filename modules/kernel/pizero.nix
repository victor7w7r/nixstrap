{ inputs, kernel, ... }:
{
  kernel.hosts.pizero =
    pkgs:
    (kernel.lib.v7w7r {
      inherit pkgs;
      localVer = "sunxi-hardened";
      src = inputs.cachyos-linux;
      config = "${(kernel.patches.injector pkgs).armbian.source}/config/kernel/linux-sunxi64-current.config";
      version = (kernel.linux.injector pkgs).version.string;
      patches =
        with kernel.patches.injector pkgs;
        cachyos.hardened ++ tachyon.std ++ bunker.hardened ++ armbian.sunxi-patches;
      extraConfig = with kernel.config.modules; [
        (cmdline { })
        default
        freq.low
        hardware.not-phone
        net
        storage.not-cdrom
        storage.f2fs
        storage.not-ntfs
        storage.not-raid
        storage.xfs
        vendor.not-vendor
        vendor.not-broadcom
      ];
    })
    |> (generated: {
      pizero-kernelPackages = generated.packages;
      pizero-kernel = generated.kernel;
      pizero-config = generated.config;
    });
}
