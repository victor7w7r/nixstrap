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
        (media.denied { })
        net.denied
        (performance.denied { })
        peripherals.denied
        security.denied
        sensors.denied
        vendor.denied
      ];

      common-arm = lib.mkMerge [
        (arch.arm { })
        (arch.denied.arm { })
        disks.denied-arm
        input.denied-arm
        peripherals.denied-arm
        sensors.denied-arm
        vendor.denied-arm
      ];

      main-generic = lib.mkMerge [
        default.common
        arch.apply-x86
        (arch.intel { })
        (arch.arm { isDenied = true; })
        (arch.rogally { isDenied = true; })
        (disks.not-mmc { })
        (disks.raid { })
        (flavour.desktop { })
        (qcom { isDenied = true; })
        (net.realtek { isDenied = true; })
        sound.denied
        (sound.rogally { isDenied = true; })
        {
          APPLE_BCE = module;
          DRM_APPLETBDRM = module;
          EEPROM_EE1004 = yes;
          HID_WACOM = module;
          SENSORS_APPLESMC_T2 = module;
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
        (arch.arm { isDenied = true; })
        (arch.intel { isDenied = true; })
        (arch.rogally { })
        (flavour.desktop { })
        (disks.mmc { })
        (qcom { isDenied = true; })
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
        (arch.arm { isDenied = true; })
        (arch.rogally { isDenied = true; })
        (arch.intel { })
        (disks.mmc { })
        (disks.raid { })
        (flavour.server { })
        (net.realtek { })
        (qcom { isDenied = true; })
        {
          CDROM = no;
          DW_DMAC = yes;
          STAGING = lib.mkForce no;
          UDF_FS = lib.mkForce no;
          XFS_FS = yes;
        }
      ];

      pizero = lib.mkMerge [
        (arch.not-broadcom { })
        default.common
        default.common-arm
        (arch.intel { isDenied = true; })
        (arch.rogally { isDenied = true; })
        (arch.sunxi { })
        (disks.mmc { })
        (flavour.server { })
        (net.realtek { })
        (qcom { isDenied = true; })
        {
          AXP20X_POWER = yes;
          CDROM = no;
          IIO = yes;
          DRM_SUN4I = yes;
          DRM_SUN8I_MIXER = yes;
          DRM_GEM_DMA_HELPER = yes;
          MFD_AXP20X = yes;
          MFD_AXP20X_I2C = yes;
          MFD_AXP20X_RSB = yes;
          REGULATOR_AXP20X = yes;
          SPARD_WLAN_SUPPORT = yes;
          SUNXI_RSB = yes;
          UDF_FS = lib.mkForce no;
          UNISOC_WIFI_PS = yes;
          WLAN_UWE5622 = module;
        }
      ];

      superlab = lib.mkMerge [
        (arch.not-broadcom { })
        default.common
        default.common-arm
        (arch.intel { isDenied = true; })
        (arch.rogally { isDenied = true; })
        (disks.mmc { })
        (arch.rockchip { })
        (flavour.desktop { })
        (net.realtek { })
        sound.denied
        (sound.denied-arm { })
        (sound.rogally { isDenied = true; })
        (qcom { isDenied = true; })
        {
          CDROM = no;
          MD = lib.mkForce no;
          UDF_FS = lib.mkForce no;
          USB_EHCI_TEGRA = no;
          XFS_FS = no;
        }
      ];

      phone = lib.mkMerge [
        (arch.not-broadcom { })
        default.common
        default.common-arm
        (arch.intel { isDenied = true; })
        (arch.rogally { isDenied = true; })
        (arch.arm { })
        (disks.mmc { })
        (flavour.desktop { })
        (net.realtek { isDenied = true; })
        sound.denied
        (sound.denied-arm { })
        (sound.rogally { isDenied = true; })
        (qcom { })
        {
          CDROM = no;
          HIBERNATION = no;
          MD = lib.mkForce no;
          UDF_FS = lib.mkForce no;
          USB_EHCI_TEGRA = no;
          XFS_FS = no;
        }
      ];
    };
}
