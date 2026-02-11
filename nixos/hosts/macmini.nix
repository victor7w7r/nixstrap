{ pkgs, ... }:
let
  intelParams = import ./lib/intel-params.nix;
  params = import ./lib/params.nix;
  boot = (import ./lib/boot.nix) { };
  btrfs = (import ./lib/btrfs.nix);
  zfs = import ./lib/zfs.nix;
  shared = (import ./lib/shared.nix) { };
in
{
  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    inherit (shared) "/run/media/shared";
    "/" = zfs { };
    "/nix" = zfs { dataset = "nix"; };
    "/nix/persist" = zfs { dataset = "persist"; };
    "/nix/persist/etc" = btrfs {
      hasSubvol = false;
      device = "/dev/disk/by-partlabel/disk-main-sysetc";
    };
    "/nix/persist/storage" = zfs {
      pool = "sz";
      dataset = "storage";
    };
  };

  boot = {
    kernelParams = [ "intel_iommu=on" ] ++ intelParams ++ params { };
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-lts-lto-x86_64-v3;
    initrd = {
      availableKernelModules = [
        "i915"
        # "vfio_virqfd"
        # "vfio_pci"
        # "vfio_iommu_type1"
        # "vfi"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    bolt
    tbtools
    thunderbolt
    intel-undervolt
    kdePackages.plasma-thunderbolt
  ];

  hardware.intel-gpu-tools = true;
}
