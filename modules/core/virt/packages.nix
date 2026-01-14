{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    arion
    bridge-utils
    ctop
    dialog
    distrobox-tui
    distrobuilder
    dive
    fuse-overlayfs
    freerdp
    nemu
    netcat-openbsd
    oxker
    qemu-user
    qemu-utils
    pods
    podman-tui
    usbkvm
    unicorn
    virtnbdbackup
    virt-manager
    virt-viewer
    virtio-win
    x11_ssh_askpass
    waydroid-helper
    win-spice
    yad
    inputs.compose2nix.packages.x86_64-linux.default
    (pkgs.callPackage ./custom/lxtui.nix { })

    #cockpit-files
    #cockpit-machines
    #cockpit-navigator
    #cockpit-podman
    #cockpit-storaged
  ];
}
