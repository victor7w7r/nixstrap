{ pkgs, ... }:
let
  intelParams = import ./lib/intel-params.nix;
  params = import ./lib/kernel-params.nix;
  boot = import ./lib/boot.nix { };
  f2fs = import ./lib/f2fs.nix;
  shared = (import ./lib/shared.nix) { };
in
{
  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    inherit (shared) "/run/media/shared";

    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=2G"
        "mode=755"
      ];
    };

    "/nix" = f2fs {
      label = "system";
      device = "/dev/vg0/syscrypt";
    };
  };

  swapDevices = [ { device = "/dev/vg0/swapcrypt"; } ];
  boot = {
    kernelParams = [ "intel_iommu=on" ] ++ intelParams ++ params { };
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-lts-lto-x86_64-v2;
    initrd = {
      luks.devices.syscrypt = {
        device = "/dev/disk/by-partlabel/disk-emmc-systempv";
        preLVM = true;
      };
      availableKernelModules = [ "i915" ];
      kernelModules = [ "dm-snapshot" ];
    };
  };

  hardware.intel-gpu-tools = true;
}
