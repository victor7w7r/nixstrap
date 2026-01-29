{
  extraDirs ? "",
  hasVar ? true,
}:
let
  mountOptions = [
    "nodatacow"
    "lazytime"
    "noatime"
  ];
  varPart =
    if hasVar then
      {
        "/var" = {
          mountpoint = "/var";
          inherit mountOptions;
          postMountHook = "mkdir -p /var/.secured /var/.data";
        };
      }
    else
      { };
in
(import ../lib/btrfs.nix) {
  name = "rootfs";
  size = if hasVar then "5G" else "100M";
  label = "rootfs";
  lvmPool = "thinpool";
  mountOptions = [ ];
  postMountHook = ''
    mkdir -p /mnt/nix /mnt/etc /mnt/root ${extraDirs} ${if hasVar then "/mnt/var" else ""}
  '';
  subvolumes = {
    "/rootfs" = {
      mountpoint = "/";
      inherit mountOptions;
    };
  }
  // varPart;
}
