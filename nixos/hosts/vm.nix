{ modulesPath, self, ... }:
let
  params = import ./common/params.nix;
  systems = import ./common/filesystems.nix;
  security = import ./common/security.nix;

  sec = security { inherit self; };
in
{
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];
  fileSystems = systems { };
  powerManagement.cpuFreqGovernor = "ondemand";

  boot = {
    kernelParams = [
      "intel_pstate=disable"
      "i915.enable_guc=2"
      "i915.enable_psr=0"
    ]
    ++ params { };

    initrd = {
      availableKernelModules = [
        "ahci"
        "xhci_pci"
        "sr_mod"
      ];
      secrets = sec.secrets;
      luks.devices = {
        system = sec.system;
      };
    };
  };
}
