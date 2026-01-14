{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      go-mtpfs
      exfatprogs
      f2fs-tools
      mtools
      viddy
      simple-mtpfs
      sshfs
    ]
    ++ [
      gpart
      ntfs2btrfs
      partclone
      tparted
      wiper
      wipefreespace
      #https://aur.archlinux.org/packages/chkufsd-bin
      #https://github.com/benapetr/compress
      #https://github.com/gdelugre/ext4-crypt
      #https://aur.archlinux.org/packages/ntfs3-dkms-git
      #https://aur.archlinux.org/packages/udefrag
      compsize
      fsarchiver
      httm
      #https://github.com/ximion/btrfsd
    ]
    ++ [
      cshatag
      ddrescue
      ddrutility
      ext4magic
      extundelete
      foremost
      magicrescue
      myrescue
      safecopy
      scrounge-ntfs
      stresss
      testdisk
      #https://aur.archlinux.org/packages/r-linux
      (pkgs.callPackage ./custom/btrfs-du.nix { })
      (pkgs.callPackage ./custom/btrfs-data-recovery.nix { })
    ]
    ++ [
      cpulimit
      cyme
      dippi
      dysk
      dmidecode
      edid-decode
      edid-generator
      fanctl
      fan2go
      i2c-tools
      hwinfo
      lm_sensors
      lshw
      read-edid
      rwedid
      smartmontools
      usbutils
    ];

}
