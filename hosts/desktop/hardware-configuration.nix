{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")

  ];
  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "virtio_pci"
    "virtio_scsi"
    "sr_mod"
    "virtio_blk"
  ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = {
    device = "/dev/mapper/vg0-fstemp";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/.rootfs" = {
    device = "/dev/mapper/vg0-system";
    fsType = "ext4";
  };

  fileSystems."/.varfs" = {
    device = "/dev/mapper/vg0-var";
    fsType = "ext4";
  };

  fileSystems."/media/ext" = {
    device = "/dev/mapper/vg0-home";
    fsType = "ext4";
  };

  fileSystems."/etc" = {
    device = "/.rootfs/etc";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/usr" = {
    device = "/.rootfs/usr";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/nix" = {
    device = "/.rootfs/nix";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/root" = {
    device = "/.varfs/root";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/var" = {
    device = "/.varfs/var";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/home" = {
    device = "/media/ext/.fs/home";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/opt" = {
    device = "/media/ext/.fs/opt";
    fsType = "none";
    options = [ "bind" ];
  };

  swapDevices = [ ];
}
