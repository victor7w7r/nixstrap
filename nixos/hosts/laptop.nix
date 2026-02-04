{ ... }:
let
  intelParams = import ./lib/intel-params.nix;
  params = import ./lib/kernel-params.nix;
  boot = import ./filesystems/boot.nix { };
  builder =
    {
      subvol ? "",
      isNix ? false,
      depends ? [ ],
    }:
    {
      device = "/dev/vg0/system";
      fsType = "btrfs";
      options = [
        "lazytime"
        "noatime"
        "compress=zstd"
        "subvol=@${subvol}"
      ]
      ++ (if isNix then [ "noacl" ] else [ ]);
      inherit depends;
      neededForBoot = true;
    };

in
{
  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    "/" = builder { };
    "/nix" = builder { subvol = "nix"; };
    "/nix/persist" = builder {
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
