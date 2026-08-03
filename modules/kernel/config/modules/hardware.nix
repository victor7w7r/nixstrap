{
  kernel.config.modules.hardware = rec {
    desktop = not-arm // x86;
    desktop-wserial = desktop // not-serial;

    not-serial = {
      USB_ACM = "n";
      USB_SERIAL = "n";
    };

    realtek = {
      REALTEK_PHY = "y";
      R8169 = "y";
    };

    not-realtek = {
      REALTEK_PHY = "n";
      R8169 = "n";
    };

    serial = {
      USB_ACM = "y";
    };

    generic = {
      GENERIC_CPU = "y";
      MZEN4 = "n";
      X86_NATIVE_CPU = "n";
      X86_64_VERSION = "2";
    };

    native = {
      GENERIC_CPU = "n";
      X86_NATIVE_CPU = "y";
    };

    arm = {
      SPI = "y";
      SPI_BITBANG = "y";
      SPI_DYNAMIC = "y";
      SPI_MASTER = "y";
      SPI_MEM = "y";
      SPI_SLAVE = "y";
    };

    not-arm = {
      CRYPTO_DES = "n";
      MFD_AXP20X_I2C = "n";
      MFD_WM8994 = "n";
      MHI_BUS = "n";
      MOTORCOMM_PHY = "n";
      NET_VENDOR_STMICRO = "n";
      NOP_USB_XCEIV = "n";
      PCS_XPCS = "n";
      QRTR = "n";
      RAID_ATTRS = "n";
      REALTEK_PHY_HWMON = "n";
      STM = "n";
      USB_CHIPIDEA = "n";
      USB_GADGET = "n";
      USB_MUSB_HDRC = "n";
    }
    // not-phone;

    not-phone = {
      BACKLIGHT_QCOM_WLED = "n";
      GNSS = "n";
      NFC = "n";
      N_GSM = "n";
      SCSI_UFSHCD = "n";
      SOUNDWIRE_QCOM = "n";
      USB_DWC2 = "n";
      USB_DWC3 = "n";
    };

    x86 = {
      ACPI_BUTTON = "y";
      ACPI_TAD = "y";
      ACPI_WMI = "y";
      INPUT_TOUCHSCREEN = "n";
      MMC_MTK = "n";
      OF = "n";
      PCIE_DPC = "y";
      PCIE_EDR = "y";
      PCIE_PTM = "y";
      PCI_DOE = "y";
      PCI_IOV = "y";
      PERF_EVENTS_INTEL_RAPL = "y";
      #SPI = "n"; # CHECK
      RTC_DRV_CMOS = "y";
      STAGING = "n";
      VFIO = "y";
      X86_ACPI_CPUFREQ = "y";
      X86_PKG_TEMP_THERMAL = "y";
      XZ_DEC_ARM = "n";
      XZ_DEC_ARM64 = "n";
      XZ_DEC_ARMTHUMB = "n";
    };
  };
}
