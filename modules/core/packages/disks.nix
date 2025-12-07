{ pkgs, lib, ... }:
{
  environment.systemPackages =
    with pkgs;
    lib.mkAfter [
      go-mtpfs
      exfatprogs
      f2fs-tools
      mtools
      simple-mtpfs
      sshfs

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
      #https://github.com/nachoparker/btrfs-du

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
      testdisk

      #https://aur.archlinux.org/packages/r-linux
      #https://github.com/davispuh/btrfs-data-recovery
    ];
}
