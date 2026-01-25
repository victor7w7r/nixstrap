{ self, ... }:
let
  intelParams = import ./common/intel-params.nix;
  params = import ./common/params.nix;
  security = import ./common/security.nix;
  sec = security { inherit self; };

  rootfs = (import ./filesystems/rootfs.nix) {
    hasVar = false;
  };
  boot = import ./filesystems/boot.nix { disk = "TODO"; };
  system = (import ./filesystems/system-btrfs.nix) { };
  home = (import ./filesystems/home-only.nix) { name = "TODO"; };
  store = (import ./filesystems/store-only.nix) { name = "TODO"; };
  tmp = import ./filesystems/tmp.nix;
  shared = import (import ./filesystems/shared.nix) { };
in
{
  fileSystems = {
    inherit (rootfs) "/";
    inherit (boot) "/boot" "/boot/emergency";
    inherit (tmp) "/tmp" "/var/tmp" "/var/cache";
    inherit (store) "/nix";
    inherit (home) "/home" "/.homesnaps";
    inherit (system)
      "/etc"
      "/root"
      "/.snaps"
      ;
    inherit (shared) "/run/media/shared";
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
