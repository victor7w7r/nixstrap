{
  hasVar ? true,
  varDisk ? "/dev/mapper/vg0-rootfs",
  varSubVol ? "/var",
}:
{
  "/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    neededForBoot = true;
    options = [ "mode=0755" ];
  };
}
// (
  if hasVar then
    {
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
  else
    { }
)
