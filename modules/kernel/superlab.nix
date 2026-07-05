{ kernel, ... }:
{
  kernel.hosts.superlab =
    pkgs:
    let
      src = (kernel.linux.injector pkgs).cachyos;
      version = kernel.lib.calc-version pkgs src;
      patchesData = kernel.patches.injector pkgs;
      cachyosPatches = patchesData.cachyos version.majorMinor;
      tachyonPatches = patchesData.tachyon;
      bunkerPatches = patchesData.bunker;
    in
    (kernel.lib.v7w7r {
      inherit pkgs src;
      version = version.string;
      config = "${patchesData.armbian.source}/config/kernel/linux-rockchip64-current.config";
      localVer = "rockchip";
      patches =
        cachyosPatches.common
        ++ tachyonPatches.common
        ++ tachyonPatches.notGaming
        ++ bunkerPatches.common
        ++ patchesData.armbian.rockchip-patches;
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
      ];
    })
    |> (generated: {
      superlab-config = generated.config;
      superlab-kernelPackages = generated.packages;
      superlab-kernel = generated.kernel;
    });
}
