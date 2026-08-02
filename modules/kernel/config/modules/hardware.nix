{
  kernel.config.modules.hardware = rec {
    desktop = not-arm // x86;
    desktop-wserial = desktop // not-serial;

    not-serial = {
      USB_ACM = "n";
      USB_SERIAL = "n";
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

    not-arm = {
      AX88796B_PHY = "n";
      CRYPTO_DES = "n";
      MFD_AXP20X = "n";
      MFD_AXP20X_I2C = "n";
      MFD_WM8994 = "n";
      MHI_BUS = "n";
      MICROCHIP_PHY = "n";
      MOTORCOMM_PHY = "n";
      NET_VENDOR_STMICRO = "n";
      NOP_USB_XCEIV = "n";
      PCS_XPCS = "n";
      QRTR = "n";
      RAID_ATTRS = "n";
      REALTEK_PHY = "n";
      REALTEK_PHY_HWMON = "n";
      SMSC_PHY = "n";
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
      ACPI_TAD = "y";
      ACPI_WMI = "y";
      INPUT_TOUCHSCREEN = "n";
      PCIE_DPC = "y";
      PCIE_PTM = "y";
      PCIE_EDR = "y";
      PCI_DOE = "y";
      PCI_ECAM = "y";
      PCI_IOV = "y";
      PCI_NPEM = "y";
      MMC_MTK = "n";
      OF = "n";
      SPI = "n";
      STAGING = "n";
      XZ_DEC_ARM = "n";
      XZ_DEC_ARMTHUMB = "n";
      XZ_DEC_ARM64 = "n";
      X86_ACPI_CPUFREQ = "y";
      X86_X32 = "y";
    };
  };
}
