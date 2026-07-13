{ inputs, kernel, ... }:
{
  kernel.hosts.generic =
    pkgs:
    (kernel.lib.v7w7r {
      inherit pkgs;
      localVer = "v2";
      src = inputs.cachyos-linux;
      config = (kernel.linux.injector pkgs).kConfig false;
      version = (kernel.linux.injector pkgs).version.string;
      patches = with kernel.patches.injector pkgs; cachyos.std ++ tachyon.std ++ bunker.std;
      extraConfig = with kernel.config.modules; [
        (cmdline { })
        default
        freq.high
        hardware.desktop
        hardware.generic
        hardware.serial
        net
        storage.not-raid
        storage.xfs
        vendor.not-vendor
      ];
    })
    |> (generated: {
      generic-kernelPackages = generated.packages;
      generic-kernel = generated.kernel;
      generic-config = generated.config;
    });
}
