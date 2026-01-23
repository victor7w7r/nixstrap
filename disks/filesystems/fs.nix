{
  extraDirs ? "",
}:
(import ../lib/btrfs.nix) {
  name = "fs";
  size = "5G";
  label = "fs";
  mountOptions = [ ];
  subvolumes = {
    "/var" = {
      mountpoint = "/var";
      mountOptions = [
        "nodatacow"
        "lazytime"
        "noatime"
      ];
    };
    "/rootfs" = {
      mountpoint = "/";
      mountOptions = [
        "nodatacow"
        "lazytime"
        "noatime"
      ];
    };
  };
  postMountHook = ''
    mkdir -p /mnt/nix /mnt/etc /mnt/root ${extraDirs}
  '';
}
