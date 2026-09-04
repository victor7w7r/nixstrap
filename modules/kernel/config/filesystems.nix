{ kernel, lib, ... }: {
  kernel.config.filesystems = with lib.kernel; {
    apply =
      with kernel.config.filesystems;
      lib.mkMerge [
        (include { })
        denied
      ];

    include = { }: {
      BTRFS_FS = yes;
      ECRYPT_FS_MESSAGING = yes;
      EFIVAR_FS = yes;
      EROFS_FS = yes;
      EXT4_FS = yes;
      F2FS_CHECK_FS = yes;
      F2FS_FS = yes;
      F2FS_FS_COMPRESSION = yes;
      F2FS_FS_SECURITY = yes;
      F2FS_FS_ZSTD = yes;
      F2FS_IOSTAT = yes;
      F2FS_STAT_FS = yes;
      F2FS_UNFAIR_RWSEM = yes;
      NTFS3_64BIT_CLUSTER = yes;
      ZRAM = lib.mkForce yes;
    };

    denied = lib.mkMerge [
      {
        ADFS_FS = no;
        AFFS_FS = no;
        AFS_FS = no;
        AIX_PARTITION = no;
        BEFS_FS = no;
        BFS_FS = no;
        BSD_DISKLABEL = lib.mkForce no;
        CODA_FS = no;
        CRAMFS = no;
        CUSE = no;
        EFS_FS = no;
        EXT2_FS = no;
        GFS2_FS = no;
        HFSPLUS_FS = no;
        HFS_FS = no;
        HPFS_FS = no;
        JFS_FS = no;
        JFFS2_FS = no;
        KARMA_PARTITION = no;
        LDM_PARTITION = lib.mkForce no;
        MAC_PARTITION = no;
        MINIX_FS = no;
        MINIX_SUBPARTITION = no;
        NETFS_DEBUG = no;
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
        SQUASHFS = no;
        TMPFS_QUOTA = no;
        UFS_FS = no;
        UBIFS_FS = no;
        VXFS_FS = no;
        XFS_QUOTA = lib.mkForce no;
        XZ_DEC_POWERPC = no;
        XZ_DEC_RISCV = no;
        XZ_DEC_SPARC = no;
        ZONEFS_FS = no;
        ZRAM_BACKEND_842 = lib.mkForce no;
      }
    ];
  };
}
