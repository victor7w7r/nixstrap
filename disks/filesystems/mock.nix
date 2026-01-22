{
  extraDirs ? "",
}:
(import ../lib/btrfs.nix) {
  name = "fstemp";
  size = "100M";
  label = "fstemp";
  mountpoint = "/";
  mountOptions = [
    "nodatasum"
    "nodatacow"
  ];
  postMountHook = ''
    mkdir -p /mnt/nix /mnt/etc /mnt/root ${extraDirs}
  '';
}
