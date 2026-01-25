{
  imports = [
    (import ./emergency.nix)
    (import ./home-only.nix)
    (import ./kvm.nix)
    (import ./rootfs.nix)
    (import ./shared.nix)
    (import ./store-only.nix)
    (import ./system-btrfs.nix)
    (import ./system-xfs.nix)
    (import ./var-only.nix)
  ];
}
