{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/disk-main-EFI";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/" = {
    device = "/dev/mapper/vg0-fstemp";
    fsType = "ext4";
  };

  boot = {
    kernelParams = [
      #"intel_pstate=disable"
      #"i915.enable_guc=2"
      #"i915.enable_psr=0"
      "kvm.ignore_msrs=1"
      #"kvm.nx_huge_pages=off"
      #"kvm.report_ignored_msrs=0"
      #"kvm_intel.emulate_invalid_guest_state=0"
      #"kvm_intel.nested=1"
    ];
    initrd = {
      availableKernelModules = [
        "ahci"
        "xhci_pci"
        "virtio_pci"
        "virtio_scsi"
        "sr_mod"
        "virtio_blk"
        #"i915"
        #"ext4"
      ];
      kernelModules = [ "dm-snapshot" ];
    };
  };

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
}
