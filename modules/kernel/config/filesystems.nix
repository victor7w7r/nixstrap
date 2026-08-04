{ kernel, lib, ... }: {
  kernel.config.filesystems = with lib.kernel; {
    apply = with kernel.config.filesystems; include // denied;

    include = {
      ECRYPT_FS = yes;
      ECRYPT_FS_MESSAGING = yes;
      EFIVAR_FS = yes;
      SQUASHFS = yes;
      ZRAM = lib.mkForce yes;
    };

    xfs = {
      XFS_FS = yes;
    };

    not-xfs = {
      XFS_FS = no;
    };

    ntfs = {
      NTFS3_FS = module;
      NTFS3_LZX_XPRESS = yes;
      NTFS3_FS_POSIX_ACL = yes;
    };

    not-ntfs = {
      NTFS3_FS = no;
    };

    not-cdrom = {
      CDROM = no;
      UDF_FS = no;
    };

    f2fs = {
      F2FS_FS = yes;
    };

    not-f2fs = {
      F2FS_FS = no;
    };

    denied = lib.mkMerge [
      {
        ADFS_FS = no;
        AFFS_FS = no;
        AFS_FS = no;
        AIX_PARTITION = no;
        BEFS_FS = no;
        BFS_FS = no;
        BSD_DISKLABEL = no;
        CODA_FS = no;
        CRAMFS = no;
        CUSE = no;
        EFS_FS = no;
        EROFS_FS = no;
        EXT2_FS = no;
        GFS2_FS = no;
        HFSPLUS_FS = no;
        HFS_FS = no;
        HPFS_FS = no;
        JFS_FS = no;
        KARMA_PARTITION = no;
        LDM_PARTITION = no;
        MAC_PARTITION = no;
        MINIX_FS = no;
        MINIX_SUBPARTITION = no;
        NILFS2_FS = no;
        NTFS_FS = no;
        OCFS2_FS = no;
        OMFS_FS = no;
        ORANGEFS_FS = no;
        QNX4FS_FS = no;
        QNX6FS_FS = no;
        QUOTA = no;
        ROMFS_FS = no;
        SOLARIS_X86_PARTITION = no;
        TMPFS_QUOTA = no;
        UFS_FS = no;
        VXFS_FS = no;
        XFS_QUOTA = no;
        XZ_DEC_POWERPC = no;
        XZ_DEC_RISCV = no;
        XZ_DEC_SPARC = no;
        ZONEFS_FS = no;
        ZRAM_BACKEND_842 = no;
      }
    ];
  };
}
