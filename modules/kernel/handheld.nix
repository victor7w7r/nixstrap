{ kernel, ... }:
{
  kernel.hosts.handheld =
    pkgs:
    let
      src = (kernel.linux.injector pkgs).cachyos;
      version = kernel.lib.calc-version pkgs src;
      patchesData = kernel.patches.injector pkgs;
      cachyosPatches = patchesData.cachyos version.majorMinor;
      bunkerPatches = patchesData.bunker;
      tachyonPatches = patchesData.tachyon;
    in
    (kernel.lib.v7w7r {
      inherit src pkgs;
      localVer = "handheld-native";
      config = (kernel.linux.injector pkgs).kConfig false;
      version = version.string;
      patches =
        cachyosPatches.common
        ++ cachyosPatches.handheld
        ++ tachyonPatches.common
        ++ tachyonPatches.gaming
        ++ bunkerPatches.common
        ++ patchesData.asus;
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
      ];
    })
    |> (generated: {
      handheld-kernelPackages = generated.packages;
      handheld-kernel = generated.kernel;
      handheld-config = generated.config;
    });
}
