{ config, modulesPath, ... }:
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
      device = "/dev/mapper/syscrypt";
      fsType = "btrfs";
      options = [
        "lazytime"
        "noatime"
        "compress=ztd"
        "subvol=@${subvol}"
      ]
      ++ (if isNix then [ "noacl" ] else null);
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

  swapDevices = [ { device = "/dev/mapper/swapcrypt"; } ];

  boot = {
    kernelParams = [
      "intel_pstate=disable"
      "i915.enable_guc=2"
      "i915.enable_psr=0"
    ]
    ++ params { };

    initrd = {
      luks.devices = {
        syscrypt = {
          device = "/dev/mapper/syscrypt";
          keyFile = config.sops.secrets.seckey-d.path;
        };
        swapcrypt = {
          device = "/dev/mapper/swapcrypt";
          keyFile = config.sops.secrets.seckey-d.path;
        };
      };
      availableKernelModules = [
        "ahci"
        "xhci_pci"
        "sr_mod"
      ];
    };
  };
}
