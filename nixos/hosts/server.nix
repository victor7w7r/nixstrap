{ pkgs, ... }:
let
  intelParams = import ./lib/intel-params.nix;
  params = import ./lib/kernel-params.nix;
  boot = (import ./lib/boot.nix) { };
  zfs = import ./lib/zfs.nix;
  f2fs = import ./lib/f2fs.nix;
in
{
  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    "/" = zfs { preDataset = "local"; };
    "/nix" = f2fs "store";
    "/nix/persist" = zfs {
      pool = "zpersist";
      dataset = "persist";
    };
    "/nix/persist/shared" = f2fs "shared";
    "/nix/persist/cloud" = zfs {
      pool = "zcloud";
      dataset = "cloud";
    };
  };

  swapDevices = [ { device = "/dev/zvol/zswap/local/swap"; } ];
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
