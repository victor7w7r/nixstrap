{ kernel, ... }:
{
  kernel.hosts.main =
    pkgs:
    let
      src = (kernel.linux.injector pkgs).cachyos;
      version = kernel.lib.calc-version pkgs src;
    in
    (kernel.lib.v7w7r {
      inherit pkgs src;
      localVer = "native";
      config = (kernel.linux.injector pkgs).kConfig false;
      version = version.string;
      patches =
        with kernel.patches.injector pkgs;
        (cachyos version.majorMinor).common ++ tachyon.common ++ tachyon.notGaming ++ bunker.common;
      extraConfig = with kernel.config.modules; [
        (cmdline {
          isIntel = true;
          isSata = true;
          extra = "video=DP-3:1600x900@60";
        })
        default
        freq.high
        hardware.desktop
        hardware.native
        hardware.serial
        net
        storage.ntfs
        storage.not-raid
        storage.xfs
        vendor.intel
      ];
    })
    |> (generated: {
      main-kernelPackages = generated.packages;
      main-kernel = generated.kernel;
      main-config = generated.config;
    });
}
