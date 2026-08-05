{ lib, ... }: {
  kernel.config.filesystems = with lib.kernel; {

    include = { }: {
      ECRYPT_FS = yes;
      ECRYPT_FS_MESSAGING = yes;
      EFIVAR_FS = yes;
      NTFS3_FS = module;
      NTFS3_LZX_XPRESS = yes;
      NTFS3_FS_POSIX_ACL = yes;
      SQUASHFS = yes;
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
        EROFS_FS = no;
        EXT2_FS = no;
        GFS2_FS = no;
        HFSPLUS_FS = no;
        HFS_FS = no;
        HPFS_FS = no;
        JFS_FS = no;
        KARMA_PARTITION = no;
        LDM_PARTITION = lib.mkForce no;
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
