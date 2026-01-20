{ pkgs, lib, ... }:
{
  boot = {
    loader.grub.memtest86.enable = true;
    kernelModules = [ "rtl8821cu" ];
    kernel.sysctl."vm.overcommit_memory" = "1";
    kernelParams = [
      "add_efi_memmap"
      "mitigations=off"
      "vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166"
      "vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173"
      "vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"
    ];
    kernelPackages = pkgs.linuxPackages_cachyos-lts;
    supportedFilesystems = lib.mkForce [
      "btrfs"
      "ext4"
      "exfat"
      "f2fs"
      "ntfs"
      "vfat"
      "xfs"
    ];
  };
}
