{ pkgs, self, ... }:
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
    kernelPackages= pkgs.cachyosKernels.linuxPackages-cachyos-lts-lto-x86_64-v3;
    initrd = {
      availableKernelModules = [
        "i915"
        # "vfio_virqfd"
        # "vfio_pci"
        # "vfio_iommu_type1"
        # "vfi"
      ];
      secrets = {
        #"/extkey.key" = /run/secrets/extkey.key;
      }
      // sec.secrets;
      luks.devices = {
        system = sec.system;
        /*
          storage = {
          device = "/dev/disk/by-label/storage";
          keyFile = "/extkey.key";
          preLVM = true;
          };
        */
      };
    };
  };

  environment.systemPackages = with pkgs; [
    bolt
    tbtools
    thunderbolt
    kdePackages.plasma-thunderbolt
  ];

  hardware.intel-gpu-tools = true;
}
