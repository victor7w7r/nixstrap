{ modulesPath, ... }:
let
  systems = import ./common/filesystems.nix;
  params = import ./common/params.nix;
  security = import ./common/security.nix;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (import ./../../modules/core)
    (import ./../../modules/home)
  ];

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
        "virtio_pci"
        "virtio_scsi"
        "sr_mod"
        "virtio_blk"
      ];
      kernelModules = [
        "dm-snapshot"
        "virtio_console"
        "8250_pci"
      ];
      secrets = security.secrets;
      luks.devices = {
        system = security.system;
      };
    };
  };
}
