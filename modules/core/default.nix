{ host, ... }:
{
  imports = [
    (import ./bootloader.nix)
    (import ./kernel.nix)
    (import ./mounts.nix)
    (import ./software.nix)
    (import ./security.nix)
    (import ./services.nix)
    (import ./system.nix)
    (import ./login-manager.nix)
    (import ./user.nix)
  ]
  ++ (if (host == "server") then [ (import ./server.nix) ] else [ ])
  ++ (if (host != "vm") then [ (import ./kvm.nix) ] else [ ]);
  #++ [ (import ./wayland.nix) ]
  #++ [ (import ./overlays.nix) ]
}
