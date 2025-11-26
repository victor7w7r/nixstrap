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
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/vg0/fstemp";
    fsType = "ext4";
  };

  fileSystems."/.rootfs" = {
    device = "/dev/vg0/system";
    fsType = "ext4";
  };

  fileSystems."/.varfs" = {
    device = "/dev/vg0/var";
    fsType = "ext4";
  };

  fileSystems."/media/ext" = {
    device = "/dev/vg0/home";
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

  fileSystems."/boot" = {
    device = "/.varfs/boot";
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

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/.varfs/boot/efi" = {
    device = "/boot/efi";
    fsType = "none";
    options = [ "bind" ];
  };

  swapDevices = [ ];
}
