{ ... }:
{
  imports =
    [ (import ./bootloader.nix) ]
    ++ [ (import ./kernel.nix) ]
    ++ [ (import ./mounts.nix) ]
    ++ [ (import ./software.nix) ]
    ++ [ (import ./hardware.nix) ]
    ++ [ (import ./security.nix) ]
    ++ [ (import ./services.nix) ]
    ++ [ (import ./system.nix) ]
    ++ [ (import ./login-manager.nix) ]
    ++ [ (import ./user.nix) ];
    #++ [ (import ./wayland.nix) ]
    #++ [ (import ./kvm.nix) ];
    #++ [ (import ./overlays.nix) ]
}