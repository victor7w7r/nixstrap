{ inputs, kernel, ... }:
{
  kernel.hosts.handheld =
    pkgs:
    (kernel.lib.v7w7r {
      inherit pkgs;
      localVer = "handheld-native";
      src = inputs.cachyos-linux;
      config = (kernel.linux.injector pkgs).kConfig false;
      version = (kernel.linux.injector pkgs).version.string;
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
}
