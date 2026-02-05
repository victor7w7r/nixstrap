{ config, self, ... }:
let
  intelParams = import ./common/intel-params.nix;
  params = import ./common/params.nix;
  security = import ./common/security.nix;
  sec = security { inherit self; };

  rootfs = (import ./filesystems/rootfs.nix) {
    hasVar = false;
  };
  boot = import ./filesystems/boot.nix { disk = "TODO"; };
  systembtrfs = (import ./filesystems/system-btrfs.nix) { };
  home = (import ./filesystems/home-only.nix) { name = "TODO"; };
  store = (import ./filesystems/store-only.nix) { name = "TODO"; };
  shared = (import ./filesystems/shared.nix) { };
in
{
  imports = [ import ./kernels ];
  fileSystems = {
    inherit (rootfs) "/";
    inherit (boot) "/boot" "/boot/emergency";
    inherit (store) "/nix";
    inherit (home) "/home" "/.homesnaps";
    inherit (systembtrfs)
      "/etc"
      "/root"
      "/.snaps"
      ;
    inherit (shared) "/run/media/shared";
  };

  boot = {
    kernelParams = [ "intel_iommu=on" ] ++ intelParams ++ params { };
    kernelPackages = pkgs.linuxPackages-v7w7r-server;
    zfs.package = config.boot.kernelPackages.zfs_cachyos;
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
