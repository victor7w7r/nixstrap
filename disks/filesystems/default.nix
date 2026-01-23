{
  imports = [
    (import ./home.nix)
    (import ./kvm.nix)
    (import ./mock.nix)
    (import ./shared.nix)
    (import ./system-xfs.nix)
    (import ./var.nix)
    (import ./windows.nix)
  ];
}
