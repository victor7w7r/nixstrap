{ kernel, lib, ... }: {
  kernel.config = {
    utils.setupDenial = isDenied: response: if isDenied then lib.kernel.no else response;
    default =
      with kernel.config;
      with lib.kernel;
      {
        common = lib.mkMerge [
          features.apply
          filesystems.apply
          net.apply
          peripherals.denied
          security.apply
          sensors.denied
          vendor.denied
        ];

        common-arm = lib.mkMerge [
          peripherals.denied-arm
          sensors.denied-arm
          (vendor.denied-arm { })
        ];

        main = lib.mkMerge [
          default.common
          (disks.apply { hasRaid = true; })
          (flavour.desktop { })
          (input.apply { })
          (qcom { isDenied = true; })
          (sound.apply { isIntel = true; })
          (x86.apply { isIntel = true; })
          {
            APPLE_BCE = module;
            HID_WACOM = module;
            MMC = no;
            R8169 = no;
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
          (disks.apply { hasMmc = true; })
          (flavour.desktop { })
          (input.apply { })
          (qcom { isDenied = true; })
          (sound.apply { isRogally = true; })
          (x86.apply { isRogally = true; })
          {
            CDROM = no;
            NET_VENDOR_BROADCOM = no;
            R8169 = no;
            SND_USB_AUDIO = module;
            UDF_FS = lib.mkForce no;
            XFS_FS = no;
          }
        ];

        server = lib.mkMerge [
          default.common
          (disks.apply {
            hasMmc = true;
            hasRaid = true;
          })
          (flavour.server { })
          (input.apply { })
          (qcom { isDenied = true; })
          (x86.apply { isIntel = true; })
          {
            CDROM = no;
            DW_DMAC = yes;
            NET_VENDOR_BROADCOM = no;
            R8169 = yes;
            STAGING = lib.mkForce no;
            UDF_FS = lib.mkForce no;
            XFS_FS = yes;
          }
        ];

        pizero = lib.mkMerge [
          (arm.apply { isSunxi = true; })
          default.common
          default.common-arm
          (disks.apply { hasMmc = true; })
          (flavour.server { })
          (input.apply { isArm = true; })
          (qcom { isDenied = true; })
          {
            AXP20X_POWER = yes;
            CDROM = no;
            DRM_GEM_DMA_HELPER = yes;
            DRM_SUN4I = no;
            DRM_SUN8I_MIXER = yes;
            FB_SUN5I_EINK = no;
            IIO = yes;
            MFD_AXP20X = yes;
            MFD_AXP20X_I2C = yes;
            MFD_AXP20X_RSB = yes;
            R8169 = no;
            REGULATOR_AXP20X = yes;
            SPARD_WLAN_SUPPORT = yes;
            SUNXI_RSB = yes;
            UDF_FS = lib.mkForce no;
            UNISOC_WIFI_PS = yes;
            WLAN_UWE5622 = module;
          }
        ];

        superlab = lib.mkMerge [
          (arm.apply { isRockchip = true; })
          default.common
          default.common-arm
          (disks.apply { hasMmc = true; })
          (flavour.desktop { })
          (input.apply { isArm = true; })
          (qcom { isDenied = true; })
          (sound.apply { isArm = true; })
          {
            ARM_SCMI_CPUFREQ = no;
            ARM_SCPI_CPUFREQ = yes;
            COMMON_CLK_SCPI = yes;
            CDROM = no;
            DRM_ACCEL_ROCKET = module;
            PCIE_ROCKCHIP_EP = yes;
            PCIE_ROCKCHIP_DW_EP = yes;
            PCIE_DW_PLAT_EP = yes;
            R8169 = no;
            UDF_FS = lib.mkForce no;
            USB_EHCI_TEGRA = no;
            XFS_FS = no;
          }
        ];

        phone = lib.mkMerge [
          (arm.apply { })
          default.common
          default.common-arm
          (disks.apply { hasMmc = true; })
          (flavour.desktop { })
          (input.apply { isArm = true; })
          (qcom { })
          (sound.apply { isArm = true; })
          {
            CDROM = no;
            HIBERNATION = no;
            R8169 = no;
            UDF_FS = lib.mkForce no;
            USB_EHCI_TEGRA = no;
            XFS_FS = no;
          }
        ];
      };
  };
}
