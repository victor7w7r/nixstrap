{ lib, ... }: {
  kernel.config.qcom =
    with lib.kernel;
    with kernel.config.utils;
    {
      isDenied ? true,
    }:
    lib.mkMerge [
      {
        ATH10K_PCI = setupDenial isDenied yes;
        BACKLIGHT_QCOM_WLED = setupDenial isDenied yes;
        BATTERY_BQ27XXX = setupDenial isDenied module;
        BLK_DEV_RAM = setupDenial isDenied module;
        CRYPTO_BLOWFISH = setupDenial isDenied module;
        CRYPTO_LRW = setupDenial isDenied module;
        CRYPTO_SERPENT = setupDenial isDenied module;
        CRYPTO_TWOFISH = setupDenial isDenied module;
        CRYPTO_USER_API_AEAD = setupDenial isDenied yes;
        DEFAULT_WESTWOOD = setupDenial isDenied yes;
        DRM_GUD = setupDenial isDenied module;
        DRM_PANEL_SAMSUNG_S6E3FC2X01 = setupDenial isDenied yes;
        DRM_PANEL_SAMSUNG_SOFEF00 = setupDenial isDenied yes;
        HID_RMI = setupDenial isDenied module;
        INPUT_JOYDEV = setupDenial isDenied module;
        NETLINK_DIAG = setupDenial isDenied module;
        NET_SCH_MULTIQ = setupDenial isDenied module;
        NET_SCH_PRIO = setupDenial isDenied modules;
        QCOM_SPMI_ADC5 = setupDenial isDenied yes;
        QCOM_SPMI_VADC = setupDenial isDenied yes;
        REGULATOR_QCOM_LABIBB = setupDenial isDenied yes;
        RMI4_F55 = setupDenial isDenied yes;
        RPMSG_CHAR = setupDenial isDenied yes;
        RPMSG_QCOM_GLINK_SMEM = setupDenial isDenied yes;
        SCHED_CLUSTER = setupDenial isDenied yes;
        SLIMBUS = setupDenial isDenied yes;
        TCP_CONG_BIC = setupDenial isDenied module;
        TCP_CONG_HTCP = setupDenial isDenied module;
        TCP_CONG_WESTWOOD = setupDenial isDenied yes;
      }
      (lib.optionals (!isDenied) {
        BLK_DEV_RAM_COUNT = freeform "16";
        BLK_DEV_RAM_SIZE = freeform "8192";
        BT_LE = yes;
        BT_LE_L2CAP_ECRED = yes;
        DRM_SIMPLEDRM = lib.mkForce no;
        EFI_ZBOOT = yes;
        FS_ENCRYPTION_INLINE_CRYPT = yes;
        GPIO_SHARED_PROXY = yes;
        INPUT_QCOM_SPMI_HAPTICS = module;
        LENOVO_YOGA_C630_EC = no;
        MODULE_COMPRESS_XZ = lib.mkForce no;
        MODULE_COMPRESS_ZSTD = yes;
        MODULE_DECOMPRESS = yes;
        REGULATOR_QCOM_REFGEN = yes;
        REMOTEPROC_CDEV = yes;
        NLS_ASCII = yes;
        SND_SOC_TFA98XX = module;
        SND_HWDEP = module;
        SYSFB_SIMPLEFB = lib.mkForce no;
        TOUCHSCREEN_USB_COMPOSITE = lib.mkForce no;
        USB_CONFIGFS_F_HID = yes;
        VIDEO_IMX371 = module;
        VIDEO_IMX376 = module;
        VIDEO_IMX519 = module;
        VIDEO_LC898217XC = module;
        USB_F_HID = module;
        U_SERIAL_CONSOLE = yes;
      })
      (lib.optionals (!isDenied) {
        ARCH_QCOM = yes;
        ARCH_ROCKCHIP = no;
        ARCH_SUNXI = no;
        CMA = yes;
        DMABUF_HEAPS = yes;
        DMABUF_HEAPS_CMA = yes;
        DMABUF_HEAPS_SYSTEM = yes;
        INPUT_RK805_PWRKEY = no;
        PACKET_DIAG = yes;
        RTC_DRV_HYM8563 = no;
        SENSORS_PWM_FAN = no;
        SND_SOC_ES8316 = no;
      })
      (lib.optionals (!isDenied) {
        BATTERY_PMI8998_FG = module;
        FAT_DEFAULT_UTF8 = yes;
        BT_BNEP_MC_FILTER = yes;
        BT_BNEP_PROTO_FILTER = yes;
        CHARGER_QCOM_SMB2 = module;
        CRYPTO_DEV_QCE = yes;
        DRM_MSM = yes;
        FB_SIMPLE = yes;
        FORCE_NR_CPUS = yes;
        I2C_QCOM_GENI = yes;
        INTERCONNECT_QCOM_OSM_L3 = yes;
        MFD_QCOM_RPM = yes;
        NR_CPUS = (lib.mkForce (freeform "8"));
        PHY_QCOM_QMP = yes;
        PHY_QCOM_QMP_COMBO = yes;
        PHY_QCOM_QMP_PCIE = yes;
        PHY_QCOM_QMP_UFS = yes;
        PHY_QCOM_QMP_USB = yes;
        PHY_QCOM_QUSB2 = yes;
        PHY_QCOM_USB_HS = yes;
        PHY_QCOM_USB_SNPS_FEMTO_V2 = yes;
        PSTORE_CONSOLE = yes;
        PSTORE_PMSG = yes;
        PSTORE_RAM = yes;
        PM_AUTOSLEEP = yes;
        SND_USB_AUDIO_USE_MEDIA_CONTROLLER = yes;
        POWER_RESET_QCOM_PON = yes;
        QCOM_APR = yes;
        QCOM_GSBI = yes;
        QCOM_LLCC = yes;
        QCOM_LMH = yes;
        QCOM_OCMEM = yes;
        QCOM_RMTFS_MEM = yes;
        QCOM_SOCINFO = yes;
        QCOM_SPMI_RRADC = module;
        QCOM_SPMI_TEMP_ALARM = yes;
        QCOM_WCNSS_CTRL = yes;
        QFMT_V2 = yes;
        SCSI_UFS_QCOM = yes;
        SCSI_SCAN_ASYNC = yes;
        SND_SOC_QDSP6_Q6VOICE = module;
        USB_DWC3_ULPI = yes;
        TYPEC = yes;
      })
      (lib.optionals (!isDenied) {
        HIBMCGE = no;
        NET_DSA_REALTEK = no;
        R8169 = no;
        REALTEK_PHY = no;
        TOUCHSCREEN_FTM4 = no;
        TOUCHSCREEN_STM_FTS_DOWNSTREAM = no;
        AHCI_CEVA = no;
        AHCI_MVEBU = no;
        AHCI_QORIQ = no;
        AHCI_XGENE = no;
        ALTERA_FREEZE_BRIDGE = no;
      })
    ];
}
