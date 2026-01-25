{
  varDisk ? "/dev/mapper/vg0-fs",
  varSubVol ? "/var",
}:
{
  "/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    neededForBoot = true;
    options = [ "mode=0755" ];
  };
  "/var" = {
    device = varDisk;
    fsType = "btrfs";
    options = [
      "nodatacow"
      "lazytime"
      "noatime"
      "discard=async"
      "nodatacow"
      "subvol=${varSubVol}"
    ];
  };
}
