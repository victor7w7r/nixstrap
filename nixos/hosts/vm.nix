{ modulesPath, self, ... }:
let
  sec = security { inherit self; };
  params = import ./lib/kernel-params.nix;
  security = import ./lib/security.nix;

  root-var = (import ./filesystems/root-var.nix) { };
  boot = import ./filesystems/boot.nix;
  system = (import ./filesystems/system-btrfs.nix) { };
  tmp = import ./filesystems/tmp.nix;

in
{
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  fileSystems = {
    inherit (root-var) "/" "/var";
    inherit (boot) "/boot" "/boot/emergency";
    inherit (tmp) "/tmp" "/var/tmp" "/var/cache";
    inherit (system)
      "/.nix"
      "/nix"
      "/etc"
      "/root"
      "/home"
      ;
  };
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
