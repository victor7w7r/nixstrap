{
  kernel.config.denial.storage = rec {
    all = fs // label // general // mmc // raid // scsi // sata;

    fs = {
      ADFS_FS = "n";
      AFFS_FS = "n";
      AFS_FS = "n";
      BFS_FS = "n";
      BEFS_FS = "n";
      CODA_FS = "n";
      CRAMFS = "n";
      CUSE = "n";
      EFS_FS = "n";
      EROFS_FS = "n";
      EXT2_FS = "n";
      GFS2_FS = "n";
      HFSPLUS_FS = "n";
      HFS_FS = "n";
      HPFS_FS = "n";
      JBD2 = "n";
      JFS_FS = "n";
      MINIX_FS = "n";
      NILFS2_FS = "n";
      NTFS_FS = "n";
      OCFS2_FS = "n";
      OMFS_FS = "n";
      ORANGEFS_FS = "n";
      QNX4FS_FS = "n";
      QNX6FS_FS = "n";
      QUOTA = "n";
      ROMFS_FS = "n";
      TMPFS_QUOTA = "n";
      UFS_FS = "n";
      VXFS_FS = "n";
      XFS_QUOTA = "n";
      ZONEFS_FS = "n";
    };

    label = {
      AIX_PARTITION = "n";
      BSD_DISKLABEL = "n";
      KARMA_PARTITION = "n";
      LDM_PARTITION = "n";
      MAC_PARTITION = "n";
      MINIX_SUBPARTITION = "n";
      SOLARIS_X86_PARTITION = "n";
    };

    general = {
      AF_KCM = "n";
      AF_RXRPC = "n";
      BLK_DEV_DRBD = "n";
      BLK_DEV_FD = "n";
      BLK_DEV_NBD = "n";
      BLK_DEV_PCIESSD_MTIP32XX = "n";
      BLK_DEV_RAM = "n";
      BLK_DEV_RBD = "n";
      BLK_DEV_UBLK = "n";
      CEPH_FS = "n";
      CIFS = "n";
      EDD = "n";
      MEMSTICK = "n";
      NETFS_SUPPORT = "n";
      NFSD = "n";
      NFS_FS = "n";
      NVME_FC = "n";
      NVME_TARGET = "n";
      NVME_TCP = "n";
    };

    mmc = {
      MMC_CB710 = "n";
      MMC_SDHCI_F_SDH30 = "n";
      MMC_SDHCI_XENON = "n";
      MMC_SPI = "n";
      MMC_TEST = "n";
      MMC_TIFM_SD = "n";
      MMC_TOSHIBA_PCI = "n";
      MMC_USDHI6ROL0 = "n";
      MMC_USHC = "n";
      MMC_VIA_SDMMC = "n";
      MMC_VUB300 = "n";
      MMC_WBSD = "n";
    };

    raid = {
      DM_CACHE = "n";
      DM_CLONE = "n";
      DM_DELAY = "n";
      DM_DUST = "n";
      DM_EBS = "n";
      DM_ERA = "n";
      DM_FLAKEY = "n";
      DM_LOG_USERSPACE = "n";
      DM_LOG_WRITES = "n";
      DM_MULTIPATH = "n";
      DM_SWITCH = "n";
      DM_WRITECACHE = "n";
      DM_ZONED = "n";
    };

    scsi = {
      BE2ISCSI = "n";
      BLK_DEV_3W_XXXX_RAID = "n";
      CHR_DEV_SG = "n";
      CHR_DEV_ST = "n";
      FW_CFG_SYSFS = "n";
      ISCSI_IBFT = "n";
      MEGARAID_LEGACY = "n";
      MEGARAID_NEWGEN = "n";
      MEGARAID_SAS = "n";
      SCSI_3W_9XXX = "n";
      SCSI_3W_SAS = "n";
      SCSI_AACRAID = "n";
      SCSI_ACARD = "n";
      SCSI_ADVANSYS = "n";
      SCSI_AIC79XX = "n";
      SCSI_AIC7XXX = "n";
      SCSI_AIC94XX = "n";
      SCSI_AM53C974 = "n";
      SCSI_ARCMSR = "n";
      SCSI_BNX2_ISCSI = "n";
      SCSI_BUSLOGIC = "n";
      SCSI_CXGB3_ISCSI = "n";
      SCSI_CXGB4_ISCSI = "n";
      SCSI_DC395x = "n";
      SCSI_DEBUG = "n";
      SCSI_DH = "n";
      SCSI_DMX3191D = "n";
      SCSI_ESAS2R = "n";
      SCSI_FC_ATTRS = "n";
      SCSI_FDOMAIN_PCI = "n";
      SCSI_HPSA = "n";
      SCSI_HPTIOP = "n";
      SCSI_INIA100 = "n";
      SCSI_INITIO = "n";
      SCSI_IPR = "n";
      SCSI_IPS = "n";
      SCSI_ISCI = "n";
      SCSI_MPI3MR = "n";
      SCSI_MPT2SAS = "n";
      SCSI_MPT3SAS = "n";
      SCSI_MVSAS = "n";
      SCSI_MVUMI = "n";
      SCSI_MYRB = "n";
      SCSI_MYRS = "n";
      SCSI_PM8001 = "n";
      SCSI_PMCRAID = "n";
      SCSI_QLA_ISCSI = "n";
      SCSI_QLOGIC_1280 = "n";
      SCSI_SAS_ATTRS = "n";
      SCSI_SAS_LIBSAS = "n";
      SCSI_SMARTPQI = "n";
      SCSI_SNIC = "n";
      SCSI_SPI_ATTRS = "n";
      SCSI_SRP_ATTRS = "n";
      SCSI_STEX = "n";
      SCSI_SYM53C8XX_2 = "n";
      SCSI_WD719X = "n";
    };

    sata = {
      AHCI_DWC = "n";
      ATA_OVER_ETH = "n";

      ATA_SFF = "n";
      SATA_ACARD_AHCI = "n";
      SATA_INIC162X = "n";
      SATA_SIL24 = "n";
    };
  };
}
