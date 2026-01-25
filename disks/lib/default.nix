{
  imports = [
    (import ./btrfs.nix)
    (import ./emergency.nix)
    (import ./esp.nix)
    (import ./f2fs.nix)
    (import ./luks-lvm.nix)
    (import ./lvm.nix)
    (import ./windows.nix)
    (import ./xfs.nix)
  ];
}
