{ lib, ... }: {
  kernel.config.disks = with lib.kernel; {
    include = { }: {
      BLK_DEV_NVME = yes;
      BLK_DEV_SD = yes;
      SCSI = yes;
      TYPEC = module;
      USB4 = module;
      USB_ROLE_SWITCH = module;
      USB_STORAGE = yes;
      USB_UAS = yes;
      USB_EHCI_HCD = yes;
      USB_UHCI_HCD = yes;
      USB_XHCI_HCD = yes;
    };

    not-mmc = { }: {
      MMC = no;
      MMC_BLOCK = no;
    };

    mmc = { }: {
      MMC = yes;
      MMC_BLOCK = yes;
      MMC_CQHCI = yes;
      MMC_SDHCI = yes;
      MMC_SDHCI_PCI = yes;
      MMC_SDHCI_UHS2 = yes;
      RPMB = yes;
    };

    raid = { }: {
      BLK_DEV_DM = yes;
      BLK_DEV_MD = yes;
      DM_SNAPSHOT = yes;
      DM_THIN_PROVISIONING = yes;
      DM_RAID = yes;
      MD_RAID456 = yes;
    };

    denied-arm = lib.mkMerge [
      {
        MMC_SDHCI_OF_AT91 = no;
        MMC_SDHCI_CADENCE = no;
        MMC_SDHCI_MILBEAUT = no;
        MMC_DW_BLUEFIELD = no;
        MMC_DW_EXYNOS = no;
        MMC_DW_HI3798CV200 = no;
        MMC_DW_HI3798MV200 = no;
        MMC_DW_K3 = no;
        MMC_DW_PCI = no;
        MMC_MTK = no;
        MMC_LITEX = no;
        SCSI_UFSHCD_PCI = no;
        SCSI_UFS_DWC_TC_PCI = no;
        SCSI_UFS_CDNS_PLATFORM = no;
        SCSI_UFS_DWC_TC_PLATFORM = no;
      }
    ];

    denied = lib.mkMerge [
      #DRIVERS
      {
        AF_KCM = no;
        AF_RXRPC = no;
        ALTERA_TSE = no;
        AMT = no;
        BLK_DEV_DRBD = no;
        BLK_DEV_FD = no;
        BLK_DEV_PCIESSD_MTIP32XX = no;
        BLK_DEV_RAM = no;
        BLK_DEV_RBD = no;
        BLK_DEV_UBLK = no;
        BLK_DEV_ZONED_LOOP = no;
        CEPH_FS = no;
        CIFS_DEBUG = no;
        CX_ECAT = no;
        DLM = no;
        EDD = no;
        KEBA_CP500 = no;
        MEMSTICK = no;
        MTD = no;
        NET_FC = lib.mkForce no;
        NVME_FC = no;
        NVME_TARGET = lib.mkForce no;
        NVME_TCP = no;
        PNP_DEBUG_MESSAGES = no;
      }
      #MMC
      {
        MMC_CB710 = no;
        MMC_SDHCI_F_SDH30 = no;
        MMC_SDHCI_XENON = no;
        MMC_SPI = no;
        MMC_TEST = no;
        MMC_TIFM_SD = no;
        MMC_TOSHIBA_PCI = no;
        MMC_USDHI6ROL0 = no;
        MMC_USHC = no;
        MMC_VIA_SDMMC = no;
        MMC_VUB300 = no;
        MMC_WBSD = no;
      }
      #RAID
      {
        DM_CACHE = no;
        DM_CLONE = no;
        DM_DELAY = no;
        DM_DUST = no;
        DM_EBS = no;
        DM_ERA = no;
        DM_FLAKEY = no;
        DM_LOG_USERSPACE = no;
        DM_LOG_WRITES = no;
        DM_MULTIPATH = no;
        DM_SWITCH = no;
        DM_WRITECACHE = no;
        DM_ZONED = no;
      }
      #SCSI
      {
        BE2ISCSI = no;
        BLK_DEV_3W_XXXX_RAID = no;
        CHR_DEV_ST = no;
        FW_CFG_SYSFS = no;
        ISCSI_BOOT_SYSFS = no;
        ISCSI_IBFT = no;
        ISCSI_TCP = no;
        MEGARAID_LEGACY = no;
        MEGARAID_NEWGEN = lib.mkForce no;
        MEGARAID_SAS = no;
        SCSI_3W_9XXX = no;
        SCSI_3W_SAS = no;
        SCSI_AACRAID = no;
        SCSI_ACARD = no;
        SCSI_ADVANSYS = no;
        SCSI_AIC79XX = no;
        SCSI_AIC7XXX = no;
        SCSI_AIC94XX = no;
        SCSI_AM53C974 = no;
        SCSI_ARCMSR = no;
        SCSI_BNX2_ISCSI = no;
        SCSI_BUSLOGIC = no;
        SCSI_CXGB3_ISCSI = no;
        SCSI_CXGB4_ISCSI = no;
        SCSI_DC395x = no;
        SCSI_DEBUG = no;
        SCSI_DH = no;
        SCSI_DMX3191D = no;
        SCSI_ESAS2R = no;
        SCSI_FC_ATTRS = no;
        SCSI_FDOMAIN_PCI = no;
        SCSI_HPSA = no;
        SCSI_HPTIOP = no;
        SCSI_INIA100 = no;
        SCSI_INITIO = no;
        SCSI_IPR = no;
        SCSI_IPS = no;
        SCSI_ISCI = no;
        SCSI_ISCSI_ATTRS = no;
        SCSI_LOGGING = lib.mkForce no;
        SCSI_MPI3MR = no;
        SCSI_MPT2SAS = no;
        SCSI_MPT3SAS = no;
        SCSI_MVSAS = no;
        SCSI_MVUMI = no;
        SCSI_MYRB = no;
        SCSI_MYRS = no;
        SCSI_PM8001 = no;
        SCSI_PMCRAID = no;
        SCSI_QLA_ISCSI = no;
        SCSI_QLOGIC_1280 = no;
        SCSI_SAS_ATTRS = no;
        SCSI_SAS_LIBSAS = no;
        SCSI_SMARTPQI = no;
        SCSI_SNIC = no;
        SCSI_SPI_ATTRS = no;
        SCSI_SRP_ATTRS = no;
        SCSI_STEX = no;
        SCSI_SYM53C8XX_2 = no;
        SCSI_WD719X = no;
      }
      #SATA
      {
        AHCI_DWC = no;
        ATA_OVER_ETH = no;
        ATA_SFF = lib.mkForce no;
        SATA_ACARD_AHCI = no;
        SATA_INIC162X = no;
        SATA_SIL24 = no;
      }
    ];
  };
}
