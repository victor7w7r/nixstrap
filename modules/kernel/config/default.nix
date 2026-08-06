{ kernel, lib, ... }: {
  kernel.config.default =
    with kernel.config;
    with lib.kernel;
    {
      common = lib.mkMerge [
        (disks.include { })
        (filesystems.include { })
        (input.include { })
        (net.include { })
        (performance.include { })
        (peripherals.include { })
        (security.include { })

        disks.denied
        filesystems.denied
        input.denied
        net.denied
        (performance.denied { })
        peripherals.denied
        security.denied
        sensors.denied
        vendor.denied
      ];

      main-generic = lib.mkMerge [
        default.common
        arch.apply-x86
        (arch.intel { })
        (arch.rogally { isDenied = true; })
        (disks.not-mmc { })
        (disks.raid { })
        (flavour.desktop { })
        (net.realtek { isDenied = true; })
        sound.denied
        (sound.rogally { isDenied = true; })
        {
          APPLE_BCE = module;
          EEPROM_EE1004 = yes;
          HID_WACOM = module;
          SND_HDA_CODEC_HDMI_INTEL = module;
          SND_HDA_INTEL = module;
          SND_SOC_INTEL_AVS = module;
          SND_USB_AUDIO = module;
          XFS_FS = yes;
        }
      ];

      handheld = lib.mkMerge [
        default.common
        arch.apply-x86
        (arch.not-broadcom { })
        (arch.intel { isDenied = true; })
        (arch.rogally { })
        (flavour.desktop { })
        (disks.mmc { })
        (net.realtek { isDenied = true; })
        sound.denied
        (sound.rogally { })
        {
          CDROM = no;
          MD = lib.mkForce no;
          SND_USB_AUDIO = module;
          UDF_FS = lib.mkForce no;
          XFS_FS = no;
        }
      ];

      server = lib.mkMerge [
        default.common
        arch.apply-x86
        (arch.not-broadcom { })
        (arch.intel { })
        (arch.rogally { isDenied = true; })
        (disks.mmc { })
        (disks.raid { })
        (flavour.server { })
        (net.realtek { })
        {
          CDROM = no;
          DW_DMAC = yes;
          UDF_FS = lib.mkForce no;
          XFS_FS = yes;
        }
      ];

      pizero = lib.mkMerge [
        (arch.not-broadcom { })
        default.common
        (arch.intel { isDenied = true; })
        (arch.rogally { isDenied = true; })
        (disks.mmc { })
        flavour.server
        (net.realtek { isDenied = true; })
        {
          AXP20X_POWER = yes;
          CDROM = no;
          IIO = yes;
          MD = lib.mkForce no;
          MFD_AXP20X = yes;
          MFD_AXP20X_I2C = yes;
          MFD_AXP20X_RSB = yes;
          REGULATOR_AXP20X = yes;
          SUNXI_RSB = yes;
          UDF_FS = lib.mkForce no;
          XFS_FS = yes;
        }
      ];

      superlab-phone = lib.mkMerge [
        (arch.not-broadcom { })
        default.common
        (arch.intel { isDenied = true; })
        (arch.rogally { isDenied = true; })
        (disks.mmc { })
        (flavour.desktop { })
        (net.realtek { })
        sound.denied
        (sound.rogally { isDenied = true; })
        {
          CDROM = no;
          MD = lib.mkForce no;
          UDF_FS = lib.mkForce no;
          USB_EHCI_TEGRA = no;
          XFS_FS = no;
        }
      ];
    };
}
