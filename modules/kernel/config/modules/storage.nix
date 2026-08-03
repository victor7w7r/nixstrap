{
  kernel.config.modules.storage = {
    not-cdrom = {
      CDROM = "n";
      UDF_FS = "n";
    };

    f2fs = {
      F2FS_FS = "y";
    };

    not-f2fs = {
      F2FS_FS = "n";
    };

    not-mmc = {
      MMC = "n";
      MMC_BLOCK = "n";
    };

    sd = {
      MMC_SDHCI = "y";
      MMC_SDHCI_PCI = "y";
      MMC_SDHCI_UHS2 = "y";
    };

    mmc = {
      MMC = "y";
      MMC_BLOCK = "y";
      MMC_CQHCI = "y";
    };

    ntfs = {
      NTFS3_FS = "m";
      NTFS3_LZX_XPRESS = "y";
      NTFS3_FS_POSIX_ACL = "y";
    };

    not-ntfs = {
      NTFS3_FS = "n";
    };

    raid = {
      BLK_DEV_DM = "y";
      BLK_DEV_MD = "y";
      DM_SNAPSHOT = "y";
      DM_THIN_PROVISIONING = "y";
      DM_CRYPT = "y";
      DM_RAID = "y";
      MD_RAID456 = "y";
    };

    not-raid = {
      MD = "n";
    };

    xfs = {
      XFS_FS = "y";
    };

    not-xfs = {
      XFS_FS = "n";
    };
  };
}
