{ pkgs, ... }:
let
  intelParams = import ./common/intel-params.nix;
  params = import ./common/params.nix;
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
in
{
  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    "/" = builder { };
    "/nix" = builder { dataset = "nix"; };
    "/nix/persist" = builder { dataset = "persist"; };
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

  hardware.intel-gpu-tools = true;
}
