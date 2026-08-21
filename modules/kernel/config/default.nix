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
          peripherals.apply
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
            DW_DMAC_PCI = yes;
            GPIO_ICH = module;
            HID_WACOM = module;
            MACINTOSH_DRIVERS = lib.mkForce yes;
            MMC = no;
            PINCTRL_CANNONLAKE = lib.mkForce module;
            PINCTRL_INTEL_PLATFORM = lib.mkForce module;
            R8169 = no;
            SENSORS_APPLESMC_T2 = module;
            SND_HDA_CODEC_HDMI_INTEL = module;
            SND_HDA_INTEL = module;
            SND_SOC_INTEL_AVS = module;
            SND_USB_AUDIO = module;
            XFS_FS = yes;
            ZONE_DMA = lib.mkForce yes;
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
            ARM_SCMI_POWER_CONTROL = lib.mkForce module;
            ARM_TIMER_SP804 = lib.mkForce yes;
            AXP20X_POWER = yes;
            CDROM = no;
            COMMON_CLK_PWM = lib.mkForce yes;
            DRM_GEM_DMA_HELPER = yes;
            DRM_SUN4I = no;
            DRM_SUN8I_MIXER = yes;
            FB_SUN5I_EINK = no;
            I2C_MV64XXX = lib.mkForce yes;
            I2C_GPIO = lib.mkForce yes;
            I2C_MUX_GPIO = lib.mkForce yes;
            I2C_MUX_REG = lib.mkForce yes;
            IIO = yes;
            MFD_AXP20X = yes;
            MFD_AXP20X_I2C = yes;
            MFD_AXP20X_RSB = yes;
            MFD_SUN4I_GPADC = lib.mkForce module;
            MUX_GPIO = lib.mkForce module;
            PWM_CLK = lib.mkForce module;
            PWM_DWC = lib.mkForce module;
            R8169 = no;
            REGULATOR_AXP20X = yes;
            SPARD_WLAN_SUPPORT = yes;
            SPI_MUX = lib.mkForce module;
            SPI_SUN4I = lib.mkForce yes;
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
            CDROM = no;
            COMMON_CLK_SCPI = no;
            DRM_ACCEL_ROCKET = module;
            MALI_PLATFORM_NAME = freeform "rk";
            MALI_EXPERT = yes;
            MALI_DEBUG = no;
            PCIE_DW_PLAT_EP = yes;
            PCIE_ROCKCHIP_DW_EP = yes;
            PCIE_ROCKCHIP_EP = yes;
            PM_DOMAINS = yes;
            R8169 = no;
            REGULATOR_RK806 = module;
            REGULATOR_RK8XX = yes;
            RESET_ROCKCHIP = yes;
            ROCKCHIP_PM_DOMAINS = yes;
            UDF_FS = lib.mkForce no;
            USB_EHCI_TEGRA = no;
            VEHICLE_ADC = no;
            VEHICLE_BUG_REPORT = no;
            VEHICLE_CORE = no;
            VEHICLE_DRIVER = no;
            VEHICLE_DUMMY = no;
            VEHICLE_GPIO = no;
            VEHICLE_GPIO_MCU_EXPANDER = no;
            VEHICLE_SPI = no;
            VEHICLE_SPI_PROTOCOL = no;
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
