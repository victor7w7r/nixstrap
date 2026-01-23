(import ../lib/btrfs.nix) {
  name = "system";
  size = "2G";
  label = "system";
  mountOptions = [ "compress-force=ztd:2" ];
  subvolumes = {
    "/etc".mountpoint = "/etc";
    "/root".mountpoint = "/root";
  };
}
