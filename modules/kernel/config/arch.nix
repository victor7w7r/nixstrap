{ kernel, lib, ... }: {
  kernel.config.arch = with lib.kernel; {
    native = {
      GENERIC_CPU = no;
      X86_NATIVE_CPU = yes;
    };

    generic = {
      GENERIC_CPU = yes;
      MZEN4 = no;
      X86_NATIVE_CPU = no;
      X86_64_VERSION = freeform "2";
    };

    x86 = {
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
      OF = no;
      PCIE_DPC = yes;
      PCIE_EDR = yes;
      PCIE_PTM = yes;
      PCI_DOE = yes;
      PCS_XPCS = no;
      PERF_EVENTS_INTEL_RAPL = yes;
      QRTR = no;
      RAID_ATTRS = no;
      RTC_DRV_CMOS = yes;
      STAGING = no;
      STM = no;
      USB_CHIPIDEA = no;
      USB_GADGET = no;
      USB_MUSB_HDRC = no;
      VFIO = yes;
      X86_PKG_TEMP_THERMAL = yes;
      XZ_DEC_ARM = no;
      XZ_DEC_ARM64 = no;
      XZ_DEC_ARMTHUMB = no;
    };

    not-phone = {
      INTERCONNECT = no; # ARM
      BACKLIGHT_QCOM_WLED = no;
      GNSS = no;
      NFC = no;
      N_GSM = no;
      SCSI_UFSHCD = no;
      SOUNDWIRE_QCOM = no;
      USB_DWC2 = no;
      USB_DWC3 = no;
    };
    denied = {
      apply = with kernel.config.arch.denied; acpi // x86 // virt;

      acpi = {
        ACPI_APEI_EINJ = no;
        ACPI_APEI_ERST_DEBUG = no;
        ACPI_APEI_GHES_NVIDIA = no;
        ACPI_DOCK = no;
        ACPI_EC_DEBUGFS = no;
        ACPI_HOTPLUG_MEMORY = no;
        ACPI_NFIT = no;
        ACPI_SBS = no;
        BYTCRC_PMIC_OPREGION = no;
        CHTCRC_PMIC_OPREGION = no;
        CHT_DC_TI_PMIC_OPREGION = no;
        CHT_WC_PMIC_OPREGION = no;
        TPS68470_PMIC_OPREGION = no;
        PCI_IOV = no;
      };

      x86 = {
        X86_ACPI_CPUFREQ = no;
        X86_AMD_FREQ_SENSITIVITY = no;
        X86_EXTENDED_PLATFORM = no;
        X86_PMEM_LEGACY = no;
        X86_MPPARSE = no;
        X86_PLATFORM_DRIVERS_DELL = no;
        X86_P4_CLOCKMOD = no;
        X86_POWERNOW_K8 = no;
        X86_REROUTE_FOR_BROKEN_BOOT_IRQS = no;
        X86_SGX = no;
        X86_SPEEDSTEP_CENTRINO = no;
        X86_VERBOSE_BOOTUP = no;
      };

      virt = {
        HYPERVISOR_GUEST = no;
        KVM_XEN = no;
        PVPANIC = no;
        UACCE = no;
        VBOXGUEST = no;
        VDPA = no;
        VMWARE_PVSCSI = no;
        VMWARE_VMCI = no;
      };
    };
  };
}
