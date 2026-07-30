{ kernel, ... }:
{
  kernel.hosts.handheld =
    pkgs:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "handheld-native";
      patches =
        with kernel.patches.injector pkgs;
        cachyos.handheld ++ tachyon.gaming ++ bunker.std ++ asus;
      extraConfig = with kernel.config.modules; [
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
    { pkgs, ... }:
    kernel.lib.package-gen {
      inherit pkgs;
      host = "handheld";
      cross = "x86_64-unknown-linux-gnu";
    };
}
