{ modulesPath, self, ... }:
let
  intelParams = import ./common/intel-params.nix;
  params = import ./common/params.nix;
  systems = import ./common/filesystems.nix;
  security = import ./common/security.nix;

  sec = security { inherit self; };
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  fileSystems = systems { };
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
