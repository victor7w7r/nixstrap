{ kernel, ... }:
{
  kernel.hosts.server =
    pkgs:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "server-hardened-native";
      isHardened = true;
      patches = with kernel.patches.injector pkgs; cachyos.hardened ++ tachyon.std ++ bunker.hardened;
      extraConfig = with kernel.config.modules; [
        (cmdline {
          isIntel = true;
          isSata = true;
          isSec = true;
        })
        default
        freq.low
        hardware.desktop
        hardware.serial
        hardware.native
        net
        storage.f2fs
        storage.ntfs
        storage.not-cdrom
        storage.xfs
        vendor.intel
        vendor.not-broadcom
      ];
    })
    |> (generated: {
      server-config = generated.config;
      server-kernelPackages = generated.packages;
      server-kernel = generated.kernel;
    });

  perSystem =
    { pkgs, ... }:
    kernel.lib.package-gen {
      inherit pkgs;
      host = "server";
      cross = "x86_64-unknown-linux-gnu";
    };
}
