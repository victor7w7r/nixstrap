{ pkgs, ... }:
let
  intelParams = import ./lib/intel-params.nix;
  params = import ./lib/kernel-params.nix;
  boot = import ./lib/boot.nix { };
  btrfs = (import ./lib/btrfs.nix) { };
in
{
  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    "/" = btrfs { };
    "/nix" = btrfs { subvol = "nix"; };
    "/nix/persist" = btrfs {
      subvol = "persist";
      depends = [ "/nix" ];
    };
  };

  boot = {
    kernelParams = [ "intel_iommu=on" ] ++ intelParams ++ params { };
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-lts-lto-x86_64-v3;
    initrd = {
      luks.devices.syscrypt = {
        device = "/dev/disk/by-partlabel/disk-main-systempv";
        preLVM = true;
      };
      availableKernelModules = [ "i915" ];
      kernelModules = [ "dm-snapshot" ];
    };
  };

  hardware.intel-gpu-tools = true;
}
