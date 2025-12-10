{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bridge-utils
    ctop
    dialog
    distrobox-tui
    distrobuilder
    dive
    #cockpit-files
    #cockpit-sensors
    #cockpit-machines
    #cockpit-navigator
    #cockpit-podman
    #cockpit-storaged
    fuse-overlayfs
    freerdp
    #lxtui
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
  ];

  programs = {
    mdevctl.enable = true;
  };
}
