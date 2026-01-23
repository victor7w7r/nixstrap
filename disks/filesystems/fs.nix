{
  extraDirs ? "",
}:
(import ../lib/btrfs.nix) {
  name = "fs";
  size = "5G";
  label = "fs";
  mountOptions = [
    "nodatacow"
    "commit=60"
  ];
  subvolumes = {
    "/var".mountpoint = "/var";
    "/rootfs".mountpoint = "/";
  };
  postMountHook = ''
    mkdir -p /mnt/nix /mnt/etc /mnt/root ${extraDirs}
  '';
}
