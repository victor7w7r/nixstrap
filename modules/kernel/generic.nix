{ kernel, ... }:
{
  kernel.hosts.generic =
    pkgs:
    let
      src = (kernel.linux.injector pkgs).cachyos;
      version = kernel.lib.calc-version pkgs src;
    in
    (kernel.lib.v7w7r {
      inherit pkgs src;
      localVer = "v2";
      config = (kernel.linux.injector pkgs).kConfig false;
      version = version.string;
      patches =
        with kernel.patches.injector pkgs;
        (cachyos version.majorMinor).common ++ tachyon.common ++ tachyon.notGaming ++ bunker.common;
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
