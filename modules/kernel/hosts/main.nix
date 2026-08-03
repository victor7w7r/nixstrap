{ kernel, ... }:
{
  kernel.hosts.main =
    pkgs: armCross:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "native";
      patches = with kernel.patches.injector pkgs; cachyos.std ++ tachyon.std ++ bunker.std;
      extraConfig = with kernel.config.modules; [
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
        {
          BRCMFMAC = "y";
          EEPROM_EE1004 = "y";
          SND_HDA_CODEC_HDMI_INTEL = "m";
          SND_HDA_INTEL = "y";
          SND_SOC_INTEL_AVS = "y";
          SND_USB_AUDIO = "y";
          UINPUT = "y";
        }
      ];
    })
    |> (generated: {
      main-kernelPackages = generated.packages;
      main-kernel = generated.kernel;
      main-config = generated.config;
    });

  perSystem =
    { pkgs, ... }:
    kernel.lib.package-gen {
      inherit pkgs;
      host = "main";
      cross = "x86_64-unknown-linux-gnu";
    };
}
