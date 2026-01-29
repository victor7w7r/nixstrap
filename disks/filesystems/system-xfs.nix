{
  hasHome ? false,
  hasStore ? false,
  size,
}:
(import ../lib/xfs.nix) {
  inherit size;
  name = "system";
  lvmPool = "thinpool";
  label = "system";
  mountpoint = "/.nix";
  postMountHook = ''
    mkdir -p /mnt/.nix/etc /mnt/.nix/root
    ${if hasHome then "mkdir -p /mnt/.nix/home" else ""}
    ${if hasStore then "mkdir -p /mnt/.nix/nix" else ""}
    mount --bind /mnt/.nix/root /mnt/root
    mount --bind /mnt/.nix/etc /mnt/etc
    ${if hasHome then "mount --bind /mnt/.nix/home /mnt/home" else ""}
    ${if hasStore then "mount --bind /mnt/.nix/nix /mnt/nix" else ""}
    ${if hasHome then "mkdir -p /home/.secured /home/.data" else ""}
  '';
}
