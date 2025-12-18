{ modulesPath, ... }:
let
  systems = import ./common/filesystems.nix;
  params = import ./common/params.nix;
  security = import ./common/security.nix;
  options = import ./common/options.nix;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (import ./../../modules/core)
    (import ./../../modules/home)
  ];

  fileSystems = {
    "/kvm" = {
      device = "/dev/mapper/vg0-kvm";
      fsType = "ext4";
      options = options.ext4Options;
    };
  }
  // systems { };

  powerManagement.cpuFreqGovernor = "ondemand";

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
    ]
    ++ params { };

    initrd = {
      availableKernelModules = [
        "i915"
      ];
      kernelModules = [ "dm-snapshot" ];
      secrets = security.secrets;
      luks.devices = {
        system = security.system;
      };
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
