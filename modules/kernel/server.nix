{ inputs, kernel, ... }:
{
  kernel.hosts.server =
    pkgs:
    (kernel.lib.v7w7r {
      inherit pkgs;
      localVer = "server-hardened-native";
      src = inputs.cachyos-linux;
      version = (kernel.linux.injector pkgs).version.string;
      config = (kernel.linux.injector pkgs).kConfig false;
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
}
