{ self, ... }:
let
  intelParams = import ./common/intel-params.nix;
  options = import ./common/options.nix;
  params = import ./common/params.nix;
  security = import ./common/security.nix;
  systems = import ./common/filesystems.nix;

  sec = security { inherit self; };
in
{
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
      "intel_iommu=on"
    ]
    ++ intelParams
    ++ params { };

    initrd = {
      availableKernelModules = [
        "i915"
      ];
      kernelModules = [ "dm-snapshot" ];
      secrets = sec.secrets;
      luks.devices = {
        system = sec.system;
      };
    };
  };

  hardware.intel-gpu-tools = true;
}
