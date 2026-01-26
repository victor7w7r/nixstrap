{ modulesPath, self, ... }:
let
  sec = security { inherit self; };
  params = import ./lib/kernel-params.nix;
  security = import ./lib/security.nix;

  rootfs = (import ./filesystems/rootfs.nix) { };
  boot = import ./filesystems/boot.nix { };
  systembtrfs = (import ./filesystems/system-btrfs.nix) {
    hasHome = true;
  };
  store = (import ./filesystems/store-only.nix) { };
  tmp = import ./filesystems/tmp.nix;
in
{
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  fileSystems = {
    inherit (rootfs) "/" "/var";
    inherit (boot) "/boot" "/boot/emergency";
    inherit (tmp) "/tmp" "/var/tmp" "/var/cache";
    inherit (store) "/nix";
    inherit (systembtrfs)
      "/etc"
      "/root"
      "/home"
      "/.snaps"
      ;
  };

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
