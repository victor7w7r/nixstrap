{
  extraDirs ? "",
}:
(import ../lib/btrfs.nix) {
  name = "fs";
  size = "5G";
  label = "fs";
  mountOptions = [ "commit=60" ];
  subvolumes = {
    "/var" = {
      mountpoint = "/var";
      mountOptions = [ "nodatacow" ];
    };
    "/rootfs" = {
      mountpoint = "/";
      mountOptions = [ "nodatacow" ];
    };
  };
  postMountHook = ''
    mkdir -p /mnt/nix /mnt/etc /mnt/root ${extraDirs}
  '';
}
