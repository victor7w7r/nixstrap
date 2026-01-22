{
  extraDirs ? "",
  extraBinds ? "",
}:
(import ../lib/btrfs.nix) {
  name = "system";
  size = "100%";
  label = "system";
  mountpoint = "/.nix";
  postMountHook = ''
    mkdir -p /mnt/.nix/etc /mnt/.nix/nix /mnt/.nix/root ${extraDirs}
    mount --bind /mnt/.nix/root /mnt/root
    mount --bind /mnt/.nix/etc /mnt/etc
    mount --bind /mnt/.nix/nix /mnt/nix
    ${extraBinds}
  '';
}
