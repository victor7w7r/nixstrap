{ lib, kernel, ... }:
{
  kernel.hosts.main =
    pkgs: armCross:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "native";
      patches = with kernel.patches.injector pkgs; cachyos.std ++ tachyon.std ++ bunker.std;
      structuredExtraConfig =
        with kernel.config;
        with lib.kernel;
        lib.mkMerge [
          default.common
          {
            BRCMFMAC = yes;
            EEPROM_EE1004 = yes;
            SND_HDA_CODEC_HDMI_INTEL = module;
            SND_HDA_INTEL = yes;
            SND_SOC_INTEL_AVS = yes;
            SND_USB_AUDIO = yes;
            UINPUT = yes;
          }
        ];

      /*
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

        ];
      */
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
