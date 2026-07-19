{ inputs, kernel, ... }:
{
  kernel.hosts.main =
    pkgs:
    (kernel.lib.v7w7r {
      inherit pkgs;
      localVer = "native";
      src = inputs.cachyos-linux;
      config = (kernel.linux.injector pkgs).kConfig false;
      version = (kernel.linux.injector pkgs).version.string;
      patches = with kernel.patches.injector pkgs; cachyos.std ++ tachyon.std ++ bunker.std;
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
	storage.raid
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
