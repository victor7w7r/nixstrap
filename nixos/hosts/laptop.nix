{ self, ... }:
let
  intelParams = import ./common/intel-params.nix;
  security = import ./common/security.nix;
  sec = security { inherit self; };
  params = import ./lib/kernel-params.nix;

  rootfs = (import ./filesystems/rootfs.nix) { };
  boot = (import ./filesystems/boot.nix) { };
  systemxfs = (import ./filesystems/system-xfs.nix) {
    hasHome = true;
    hasStore = true;
  };

in
{
  fileSystems = {
    inherit (rootfs) "/" "/var";
    inherit (boot) "/boot" "/boot/emergency";
    inherit (systemxfs)
      "/.nix"
      "/nix"
      "/etc"
      "/root"
      "/home"
      ;
  };

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
