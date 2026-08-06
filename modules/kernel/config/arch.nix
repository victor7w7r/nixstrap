{ kernel, lib, ... }: {
  kernel.config.arch = with lib.kernel; {
    apply-x86 =
      with kernel.config.arch;
      lib.mkMerge [
        (x86 { })
        (native { })
        (not-phone { })
        denied.apply
      ];

    native = { }: {
      GENERIC_CPU = no;
      X86_NATIVE_CPU = yes;
    };

    generic = {
      GENERIC_CPU = yes;
      MZEN4 = no;
      X86_NATIVE_CPU = no;
      X86_64_VERSION = freeform "2";
    };

    arm =
      with kernel.config.utils;
      {
        isDenied ? false,
      }:
      {
        LIBNVDIMM = setupDenial isDenied module;
      };

    x86 = { }: {
      ACPI_BUTTON = yes;
      ACPI_TAD = yes;
      ACPI_WMI = yes;
      CRYPTO_DES = no;
      INPUT_TOUCHSCREEN = no;
      MFD_AXP20X_I2C = no;
      MFD_WM8994 = no;
      MHI_BUS = no;
      MMC_MTK = no;
      MOTORCOMM_PHY = no;
      NET_VENDOR_STMICRO = no;
      NOP_USB_XCEIV = no;
      OF = lib.mkForce no;
      PCIE_DPC = yes;
      PCIE_EDR = yes;
      PCIE_PTM = yes;
      PCI_DOE = yes;
      PCS_XPCS = no;
      PERF_EVENTS_INTEL_RAPL = yes;
      QRTR = no;
      RAID_ATTRS = no;
      RTC_DRV_CMOS = yes;
      STM = no;
      USB_CHIPIDEA = no;
      USB_GADGET = no;
      USB_MUSB_HDRC = no;
      VFIO = module;
      X86_PKG_TEMP_THERMAL = yes;
      XZ_DEC_ARM = no;
      XZ_DEC_ARM64 = no;
      XZ_DEC_ARMTHUMB = no;
    };

    not-phone = { }: {
      INTERCONNECT = no; # ARM
      BACKLIGHT_QCOM_WLED = no;
      GNSS = no;
      NFC = no;
      N_GSM = no;
      SCSI_UFSHCD = no;
      SOUNDWIRE_QCOM = no;
      USB_DWC2 = no;
      USB_DWC3 = no;
      WWAN = no;
    };

    rogally =
      with kernel.config.utils;
      {
        isDenied ? false,
      }:
      {
        AMDTEE = setupDenial isDenied module;
        AMD_3D_VCACHE = setupDenial isDenied yes;
        AMD_ATL = setupDenial isDenied module;
        AMD_HFI = lib.mkForce (setupDenial isDenied yes);
        AMD_HSMP_ACPI = setupDenial isDenied module;
        AMD_HSMP_PLAT = setupDenial isDenied module;
        AMD_IOMMU = setupDenial isDenied yes;
        AMD_ISP_PLATFORM = setupDenial isDenied module;
        AMD_MEM_ENCRYPT = lib.mkForce (setupDenial isDenied yes);
        AMD_PMC = setupDenial isDenied module;
        AMD_PMF = setupDenial isDenied module;
        AMD_PRIVATE_COLOR = setupDenial isDenied yes;
        AMD_SECURE_AVIC = setupDenial isDenied yes;
        AMD_SFH_HID = setupDenial isDenied module;
        AMD_WBRF = lib.mkForce (setupDenial isDenied yes);
        ASUS_ARMOURY = setupDenial isDenied module;
        ASUS_LAPTOP = setupDenial isDenied module;
        ASUS_NB_WMI = setupDenial isDenied module;
        ASUS_WIRELESS = setupDenial isDenied module;
        ASUS_WMI = setupDenial isDenied module;
        BMC150_ACCEL = setupDenial isDenied module;
        BMI323 = setupDenial isDenied module;
        BMI323_I2C = setupDenial isDenied module;
        BMI323_SPI = setupDenial isDenied module;
        BT_MTK = setupDenial isDenied module;
        BT_MTKSDIO = setupDenial isDenied module;
        CRYPTO_DEV_CCP_DD = setupDenial isDenied module;
        CRYPTO_DEV_SP_PSP = setupDenial isDenied yes;
        DRM_AMDGPU = setupDenial isDenied module;
        DRM_RADEON = setupDenial isDenied module;
        EDAC = setupDenial isDenied yes;
        HID_ASUS = setupDenial isDenied module;
        HID_ASUS_ALLY = setupDenial isDenied module;
        HID_HAPTIC = lib.mkForce (setupDenial isDenied yes);
        HOTPLUG_PCI = setupDenial isDenied yes;
        HW_RANDOM_AMD = setupDenial isDenied module;
        I2C_HID = setupDenial isDenied module;
        I2C_HID_ACPI = setupDenial isDenied module;
        I2C_HID_CORE = setupDenial isDenied module;
        INPUT_LEDS = setupDenial isDenied module;
        KVM_AMD = setupDenial isDenied module;
        LEDS_CLASS_MULTICOLOR = setupDenial isDenied module;
        MT7921E = setupDenial isDenied module;
        MT7921S = setupDenial isDenied module;
        MT7921U = setupDenial isDenied module;
        MT7925E = setupDenial isDenied module;
        MT7925U = setupDenial isDenied module;
        NET_VENDOR_AMD = setupDenial isDenied yes;
        PERF_EVENTS_AMD_BRS = lib.mkForce (setupDenial isDenied yes);
        PERF_EVENTS_AMD_POWER = setupDenial isDenied module;
        PERF_EVENTS_AMD_UNCORE = setupDenial isDenied module;
        PINCTRL_AMD = lib.mkForce (setupDenial isDenied yes);
        SENSORS_ASUS_EC = setupDenial isDenied module;
        SENSORS_ASUS_ROG_RYUJIN = setupDenial isDenied module;
        SENSORS_ASUS_WMI = setupDenial isDenied module;
        SENSORS_K10TEMP = setupDenial isDenied module;
        SERIAL_MULTI_INSTANTIATE = setupDenial isDenied module;
        SERIO_I8042 = setupDenial isDenied yes;
        SP5100_TCO = setupDenial isDenied module;
        USB_PCI_AMD = setupDenial isDenied yes;
        X86_AMD_PLATFORM_DEVICE = lib.mkForce (setupDenial isDenied yes);
        X86_MCE_AMD = setupDenial isDenied yes;
      };

    intel =
      with kernel.config.utils;
      {
        isDenied ? false,
      }:
      {
        ACPI_PROCESSOR_AGGREGATOR = setupDenial isDenied module;
        CPU_SUP_INTEL = setupDenial isDenied yes;
        CRYPTO_AES_NI_INTEL = setupDenial isDenied module;
        DRM_I915 = setupDenial isDenied module;
        HAVE_INTEL_TXT = setupDenial isDenied yes;
        HW_RANDOM_INTEL = setupDenial isDenied module;
        I2C_I801 = setupDenial isDenied module;
        INT340X_THERMAL = setupDenial isDenied module;
        INTEL_HFI_THERMAL = lib.mkForce (setupDenial isDenied yes);
        INTEL_IDLE = lib.mkForce (setupDenial isDenied yes);
        INTEL_IDMA64 = setupDenial isDenied module;
        INTEL_IOMMU = setupDenial isDenied yes;
        INTEL_LDMA = setupDenial isDenied yes;
        INTEL_MEI = setupDenial isDenied module;
        INTEL_PCH_THERMAL = lib.mkForce (setupDenial isDenied module);
        INTEL_PMC_CORE = setupDenial isDenied module;
        INTEL_PMT_DISCOVERY = setupDenial isDenied module;
        INTEL_PMT_TELEMETRY = setupDenial isDenied module;
        INTEL_POWERCLAMP = setupDenial isDenied module;
        INTEL_RAPL = lib.mkForce (setupDenial isDenied module);
        INTEL_SOC_PMIC = lib.mkForce (setupDenial isDenied yes);
        INTEL_SOC_PMIC_CHTWC = lib.mkForce (setupDenial isDenied yes);
        INTEL_TCC_COOLING = setupDenial isDenied module;
        INTEL_TDX_HOST = setupDenial isDenied yes;
        INTEL_TURBO_MAX_3 = lib.mkForce (setupDenial isDenied yes);
        INTEL_VSEC = setupDenial isDenied module;
        INTEL_WMI_THUNDERBOLT = setupDenial isDenied module;
        KVM_INTEL = setupDenial isDenied module;
        MDIO_BUS = setupDenial isDenied yes;
        MFD_INTEL_LPSS = setupDenial isDenied module;
        MFD_INTEL_LPSS_ACPI = setupDenial isDenied module;
        MTD_SPI_NOR = setupDenial isDenied module;
        PERF_EVENTS_INTEL_CSTATE = setupDenial isDenied module;
        PERF_EVENTS_INTEL_UNCORE = setupDenial isDenied module;
        SENSORS_CORETEMP = setupDenial isDenied module;
        X86_INTEL_LPSS = lib.mkForce (setupDenial isDenied yes);
        X86_INTEL_MEMORY_PROTECTION_KEYS = setupDenial isDenied yes;
        X86_MCE_INTEL = setupDenial isDenied yes;
      };

    not-broadcom = { }: {
      BCMA = no;
      CORDIC = no;
      UIO = no;
      WLAN_VENDOR_BROADCOM = no;
      NET_VENDOR_BROADCOM = no;
    };

    denied = {
      apply = with kernel.config.arch.denied; acpi // x86 // virt;

      acpi = {
        ACPI_APEI_EINJ = no;
        ACPI_APEI_ERST_DEBUG = no;
        ACPI_APEI_GHES_NVIDIA = no;
        ACPI_DOCK = no;
        ACPI_EC_DEBUGFS = no;
        ACPI_HOTPLUG_MEMORY = lib.mkForce no;
        ACPI_NFIT = no;
        ACPI_SBS = no;
        BYTCRC_PMIC_OPREGION = lib.mkForce no;
        CHTCRC_PMIC_OPREGION = lib.mkForce no;
        CHT_DC_TI_PMIC_OPREGION = lib.mkForce no;
        CHT_WC_PMIC_OPREGION = lib.mkForce no;
        TPS68470_PMIC_OPREGION = lib.mkForce no;
        PCI_IOV = no;
      };

      x86 = {
        X86_ACPI_CPUFREQ = no;
        X86_AMD_FREQ_SENSITIVITY = no;
        X86_EXTENDED_PLATFORM = no;
        X86_PMEM_LEGACY = no;
        X86_MPPARSE = no;
        X86_PLATFORM_DRIVERS_DELL = lib.mkForce no;
        X86_P4_CLOCKMOD = no;
        X86_POWERNOW_K8 = no;
        X86_REROUTE_FOR_BROKEN_BOOT_IRQS = no;
        X86_SGX = lib.mkForce no;
        X86_SPEEDSTEP_CENTRINO = no;
        X86_VERBOSE_BOOTUP = no;
      };

      virt = {
        HYPERVISOR_GUEST = lib.mkForce no;
        KVM_XEN = no;
        PVPANIC = no;
        UACCE = no;
        VBOXGUEST = no;
        VDPA = no;
        VMWARE_PVSCSI = no;
        VMWARE_VMCI = no;
        VMXNET3 = no;
      };
    };
  };
}
