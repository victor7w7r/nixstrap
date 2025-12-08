{ lib, ... }:
with lib;
{
  powerManagement.cpuFreqGovernor = "ondemand";

  options.setupDisks = mkOption {
    type = types.attrsOf types.str;
    description = "Rutas de los discos principales del sistema.";
    default = {
      maindevice = "/dev/vda";
      mockdisk = "/dev/mapper/vg0-fstemp";
      systemdisk = "/dev/mapper/vg0-system";
      homedisk = "/dev/mapper/vg0-home";
      varDisk = "/dev/mapper/vg0-var";
      kvmDisk = "";
      extraDir = "";
      extraMount = "";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/vg0-fstemp";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-partlabel/disk-main-EFI";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  /*
    hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    };
  */

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
      luks.devices = {
        system = {
          device = "/dev/disk/by-label/SYSTEM";
          #keyFile = "/syskey.key";
          allowDiscards = true;
          preLVM = true;
        };
      };
      secrets = {
        #"/syskey.key" = /run/secrets/syskey.key;
      };
      kernelModules = [ "dm-snapshot" ];
    };
  };
}
