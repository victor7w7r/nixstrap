{ pkgs, modulesPath, ... }:
let
  params = import ./lib/kernel-params.nix;
  boot = import ./lib/boot.nix { };
  btrfs = (import ./lib/btrfs.nix);
in
{
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    "/" = btrfs { };
    "/nix" = btrfs { subvol = "nix"; };
    "/nix/persist" = btrfs {
      subvol = "persist";
      depends = [ "/nix" ];
    };
  };

  #swapDevices = [ { device = "/dev/disk/by-partlabel/disk-main-swapcrypt"; } ];

  boot = {
    kernelParams = [
      "intel_pstate=disable"
      "i915.enable_guc=2"
      "i915.enable_psr=0"
    ]
    ++ params { };
    kernelPackages = pkgs.linuxPackages_6_12;
    initrd = {
      luks.devices.syscrypt = {
        device = "/dev/disk/by-partlabel/disk-main-systempv";
        preLVM = true;
      };
      availableKernelModules = [
        "ahci"
        "xhci_pci"
        "sr_mod"
      ];
    };
  };
}
