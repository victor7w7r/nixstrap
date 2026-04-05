{ lib, ... }:
let
  supportedFilesystems = [
    "btrfs"
    "ext4"
    "exfat"
    "f2fs"
    "ntfs"
    "vfat"
  ];
in
{
  boot = {
    consoleLogLevel = 4;
    inherit supportedFilesystems;
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
      generic-extlinux-compatible.populateCmd = lib.mkDefault "/run/current-system/bin/switch-to-configuration";
    };
    tmp = {
      cleanOnBoot = true;
      useTmpfs = true;
    };
  };
}
