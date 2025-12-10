{ ... }:
{
  powerManagement.cpuFreqGovernor = "ondemand";

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

  boot.kernelParams = [
    "intel_pstate=disable"
    "i915.enable_guc=2"
    "i915.enable_psr=0"
    "kvm.ignore_msrs=1"
    "kvm.nx_huge_pages=off"
    "kvm.report_ignored_msrs=0"
    "kvm_intel.emulate_invalid_guest_state=0"
    "kvm_intel.nested=1"
  ];

  boot.initrd = {
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
    };
    secrets = {
      #"/syskey.key" = /run/secrets/syskey.key;
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    intel-gpu-tools = true;
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
