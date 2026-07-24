{
  kernel.config.modules.hardware = rec {
    desktop = not-gpio // not-arm // x86;
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

    not-gpio = {
      GPIOLIB = "n";
    };

    not-arm = {
      AX88796B_PHY = "n";
      CRYPTO_DES = "n";
      MFD_WM8994 = "n";
      MHI_BUS = "n";
      QRTR = "n";
      RAID_ATTRS = "n";
      MICROCHIP_PHY = "n";
      MICROCHIP_PHY_RDS_PTP = "n";
      MOTORCOMM_PHY = "n";
      NET_VENDOR_STMICRO = "n";
      NOP_USB_XCEIV = "n";
      REALTEK_PHY = "n";
      REALTEK_PHY_HWMON = "n";
      SMSC_PHY = "n";
      STM = "n";
      USB_ETH = "n";
      USB_CHIPIDEA = "n";
      USB_GADGET = "n";
      USB_GADGETFS = "n";
      USB_MUSB_HDRC = "n";
    }
    // not-phone;

    not-phone = {
      ATH11K = "n";
      ATH11K_PCI = "n";
      ATH12K = "n";
      BACKLIGHT_QCOM_WLED = "n";
      GNSS = "n";
      NFC = "n";
      N_GSM = "n";
      SCSI_UFSHCD = "n";
      SOUNDWIRE_QCOM = "n";
      USB_AUDIO = "n";
      USB_BDC_UDC = "n";
      USB_CDC_COMPOSITE = "n";
      USB_CDNS2_UDC = "n";
      USB_CONFIGFS = "n";
      USB_DWC2 = "n";
      USB_DWC3 = "n";
      USB_FUNCTIONFS = "n";
      USB_MASS_STORAGE = "n";
      USB_MAX3420_UDC = "n";
      USB_RAW_GADGET = "n";
      USB_SNP_CORE = "n";
      USB_U_AUDIO = "n";
      USB_U_ETHER = "n";
      USB_U_SERIAL = "n";
      USB_ZERO = "n";
      U_SERIAL_CONSOLE = "n";
    };

    x86 = {
      ACPI_TAD = "y";
      ACPI_WMI = "y";
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
      USB_LIBCOMPOSITE = "n";
      USB_EZUSB_FX2 = "n";
      XZ_DEC_ARM = "n";
      XZ_DEC_ARMTHUMB = "n";
      XZ_DEC_ARM64 = "n";
      X86_ACPI_CPUFREQ = "y";
      X86_X32 = "y";
    };
  };
}
