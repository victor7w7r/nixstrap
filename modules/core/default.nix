{ host, ... }:
{
  imports = [
    (import ./kernel.nix)
    (import ./fsmount.nix)
    (import ./services.nix)
    (import ./networking.nix)
    (import ./system.nix)
    (import ./packages.nix)
    (import ./login-manager.nix)
    (import ./users.nix)
    (import ./post-scripts.nix)
  ]
  ++ (if (host != "vm") then [ (import ./virt.nix) ] else [ ]);
}
