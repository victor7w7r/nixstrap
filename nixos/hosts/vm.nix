{ modulesPath, ... }:
let
  params = import ./lib/kernel-params.nix;
  boot = import ./filesystems/boot.nix { };
  tmp = import ./filesystems/tmp.nix;
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
        "compress=ztd"
        "subvol=@${subvol}"
      ]
      ++ (if isNix then [ "noacl" ] else [ ]);
      inherit depends;
      neededForBoot = true;
    };
in
{
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    inherit (tmp) "/tmp" "/var/tmp";
    "/" = builder { };
    "/nix" = builder { subvol = "nix"; };
    "/nix/persist" = builder {
      subvol = "persist";
      depends = [ "/nix" ];
    };
  };

  swapDevices = [ { device = "/dev/vg0/swapcrypt"; } ];

  boot = {
    kernelParams = [
      "intel_pstate=disable"
      "i915.enable_guc=2"
      "i915.enable_psr=0"
    ]
    ++ params { };

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
