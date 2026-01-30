{ config, modulesPath, ... }:
let
  params = import ./lib/kernel-params.nix;
  boot = import ./filesystems/boot.nix { };
  tmp = import ./filesystems/tmp.nix;
  builder =
    {
      subvol,
      isNix ? false,
      depends ? [ ],
    }:
    {
      device = "/dev/mapper/syscrypt";
      fsType = "btrfs";
      options = [
        "lazytime"
        "noatime"
        "compress=ztd"
        (if isNix then "noacl" else "")
        "subvol=@${subvol}"
      ];
      inherit depends;
      neededForBoot = true;
    };
in
{
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    inherit (tmp) "/tmp" "/var/tmp";
    "/" = builder { subvol = ""; };
    "/nix" = builder { subvol = "nix"; };
    "/nix/persist" = builder {
      subvol = "persist";
      depends = [ "/nix" ];
    };
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  boot = {
    kernelParams = [
      "intel_pstate=disable"
      "i915.enable_guc=2"
      "i915.enable_psr=0"
    ]
    ++ params { };

    initrd = {
      secrets."/keyinit" = config.sops.secrets.seckey-d.path;
      luks.devices.syscrypt = {
        device = "/dev/disk/by-label/systempv";
        keyFile = "/keyinit";
      };
      availableKernelModules = [
        "ahci"
        "xhci_pci"
        "sr_mod"
      ];
    };
  };
}
