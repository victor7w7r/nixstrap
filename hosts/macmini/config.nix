{ lib, ... }:
with lib;
{
  powerManagement.cpuFreqGovernor = "ondemand";

  options.setupDisks = mkOption {
    type = types.attrsOf types.str;
    description = "Rutas de los discos principales del sistema.";
    default = rec {
      maindevice = "/dev/nvme0n1";
      mockdisk = "/dev/mapper/vg0-fstemp";
      systemdisk = "/dev/mapper/vg0-system";
      homedisk = "/dev/mapper/vg1-home";
      varDisk = "/dev/mapper/vg1-var";
      kvmDisk = "/dev/mapper/vg2-kvm";
      nvmeStorageDisk = "/dev/mapper/vg0-nvmestorage";
      docsDisk = "/dev/mapper/vg3-disk";
      extraFsck = ''
        if ! e2fsck -n ${kvmDisk}; then e2fsck -y ${kvmDisk}; fi
      '';
      extraDir = "media/nvmestorage media/docs";
      extraMount = ''
        mount -t btrfs -o noatime,lazytime,nodiscard,compress-force=zstd:3,commit=60 ${nvmeStorageDisk} /sysroot/media/nvmestorage
        mount -t btrfs -o noatime,lazytime,nodiscard,compress-force=zstd:3,commit=60 ${docsDisk} /sysroot/media/docs
      '';
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

  boot = {
    kernelParams = [
      "intel_pstate=disable"
      "i915.enable_guc=2"
      "i915.enable_psr=0"
      "kvm.ignore_msrs=1"
      "kvm.nx_huge_pages=off"
      "kvm.report_ignored_msrs=0"
      "kvm_intel.emulate_invalid_guest_state=0"
      "kvm_intel.nested=1"
    ];
    initrd = {
      availableKernelModules = [
        "i915"
        "ext4"
      ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices = {
        system = {
          device = "/dev/disk/by-label/SYSTEM";
          #keyFile = "/syskey.key";
          allowDiscards = true;
          preLVM = true;
        };
        storage = {
          device = "/dev/disk/by-label/storage";
          #keyFile = "/extkey.key";
          preLVM = true;
        };
      };
      secrets = {
        #"/syskey.key" = /run/secrets/syskey.key;
        #"/extkey.key" = /run/secrets/extkey.key;
      };
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    intel-gpu-tools = true;
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };

  services = {
    pulseaudio.enable = false;
    blueman.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      extraConfig.pipewire."10-clock-quantum"."context.properties"."default.clock.min-quantum" = 1024;
    };
  };
}
