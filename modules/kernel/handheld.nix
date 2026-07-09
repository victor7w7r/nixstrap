{ kernel, ... }:
{
  kernel.hosts.handheld =
    pkgs:
    (kernel.lib.v7w7r {
      inherit pkgs;
      src = (kernel.linux.injector pkgs).cachyos;
      localVer = "handheld-native";
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
      ];
    })
    |> (generated: {
      handheld-kernelPackages = generated.packages;
      handheld-kernel = generated.kernel;
      handheld-config = generated.config;
    });
}
