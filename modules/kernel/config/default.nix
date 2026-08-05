{ kernel, lib, ... }: {
  kernel.config.default = with kernel.config; {
    common = lib.mkMerge [
      disks.apply
      filesystems.apply
      input.apply
      net.apply
      (removeAttrs performance.apply [ "__provider" ])
      peripherals.apply
      security.apply
      sensors.denied
      vendor.denied
    ];

    main-generic = lib.mkMerge [
      default.common
      arch.apply-x86
      (arch.intel { })
      (arch.rogally { isDenied = true; })
      disks.raid
      disks.not-mmc
      flavour.desktop
      (net.realtek { isDenied = true; })
      sound.denied
      (sound.rogally { isDenied = true; })
      {
        BRCMFMAC = yes;
        EEPROM_EE1004 = yes;
        SND_HDA_CODEC_HDMI_INTEL = module;
        SND_HDA_INTEL = yes;
        SND_SOC_INTEL_AVS = yes;
        SND_USB_AUDIO = yes;
        UINPUT = yes;
        XFS_FS = yes;
      }
    ];

    handheld = lib.mkMerge [
      default.common
      arch.apply-x86
      arch.not-broadcom
      (arch.intel { isDenied = true; })
      (arch.rogally { })
      flavour.desktop
      disks.mmc
      (net.realtek { isDenied = true; })
      sound.denied
      (sound.rogally { })
      {
        CDROM = no;
        MD = no;
        SND_USB_AUDIO = "y";
        UDF_FS = no;
        UINPUT = "y";
        XFS_FS = no;
      }
    ];

    server = lib.mkMerge [
      default.common
      arch.apply-x86
      arch.not-broadcom
      (arch.intel { })
      (arch.rogally { isDenied = true; })
      disks.mmc
      disks.raid
      flavour.server
      (net.realtek { })
      {
        CDROM = no;
        DW_DMAC = "y";
        RPMB = "y";
        UDF_FS = no;
        XFS_FS = yes;
      }
    ];

    pizero = lib.mkMerge [
      arch.not-broadcom
      default.common
      (arch.intel { isDenied = true; })
      (arch.rogally { isDenied = true; })
      disks.mmc
      flavour.server
      (net.realtek { isDenied = true; })
      {
        AXP20X_POWER = "y";
        CDROM = no;
        IIO = "y";
        MD = no;
        MFD_AXP20X = "y";
        MFD_AXP20X_I2C = "y";
        MFD_AXP20X_RSB = "y";
        REGULATOR_AXP20X = "y";
        SUNXI_RSB = "y";
        UDF_FS = no;
        XFS_FS = yes;
      }
    ];

    superlab-phone = lib.mkMerge [
      arch.not-broadcom
      default.common
      (arch.intel { isDenied = true; })
      (arch.rogally { isDenied = true; })
      disks.mmc
      flavour.desktop
      (net.realtek { })
      sound.denied
      (sound.rogally { isDenied = true; })
      {
        CDROM = no;
        MD = no;
        UDF_FS = no;
        UINPUT = "y";
        USB_EHCI_TEGRA = "n";
        XFS_FS = no;
      }
    ];
  };
}
