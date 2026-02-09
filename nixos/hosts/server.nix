{ pkgs, ... }:
let
  intelParams = import ./lib/intel-params.nix;
  params = import ./lib/kernel-params.nix;
  boot = (import ./filesystems/boot.nix) { };
  builder =
    {
      dataset ? "root",
      pool ? "zroot",
    }:
    {
      device = "${pool}/local/${dataset}";
      fsType = "zfs";
      options = [
        "zfsutil"
        "atime=off"
      ];
      neededForBoot = true;
    };

  emmcBuilder = label: {
    device = "/dev/disk/by-partlabel/disk-emmc-${label}";
    fsType = "f2fs";
    options = [
      "lazytime"
      "noatime"
      "compress_chksum"
      "compress_algorithm=zstd:3"
      "age_extent_cache"
      "compress_extension=so"
      "inline_xattr"
      "inline_data"
      "inline_dentry"
      "errors=remount-ro"
      "compress_extension=bin"
      "atgc"
      "flush_merge"
      "discard"
      "checkpoint_merge"
      "gc_merge"
    ];
    neededForBoot = true;
  };
in
{
  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    "/" = builder { };
    "/nix" = builder { dataset = "nix"; };
    "/nix/persist" = builder { dataset = "persist"; };
    "/nix/persist/etc" = emmcBuilder "sysetc";
    "/nix/persist/shared" = emmcBuilder "shared";
    "/nix/persist/cloud" = builder {
      pool = "zcloud";
      dataset = "cloud";
    };
    "/nix/persist/var/lib/libvirt/images" = builder { dataset = "vm"; };
  };

  boot = {
    kernelParams = [ "intel_iommu=on" ] ++ intelParams ++ params { };
    kernelPackages = pkgs.linuxPackages_6_12;
    initrd = {
      availableKernelModules = [
        "i915"
        "autofs"
        "tpm-tis"
      ];
      kernelModules = [ "" ];
    };
  };

  #hardware.intel-gpu-tools = true;
}
