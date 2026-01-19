{
  modulesPath,
  pkgs,
  self,
  ...
}:
let
  intelParams = import ./common/intel-params.nix;
  options = import ./common/options.nix;
  params = import ./common/params.nix;
  systems = import ./common/filesystems.nix;
  security = import ./common/security.nix;

  sec = security { inherit self; };
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  fileSystems = {
    "/kvm" = {
      device = "/dev/mapper/vg2-kvm";
      fsType = "ext4";
      options = options.ext4Options;
    };
    "/media/nvmestorage" = {
      device = "/dev/mapper/vg2-kvm";
      fsType = "btrfs";
      options = options.btrfsOptions;
    };
    "/media/docs" = {
      device = "/dev/mapper/vg3-docs";
      fsType = "btrfs";
      options = options.btrfsOptions;
    };
  }
  // systems {
    homeDisk = "/dev/mapper/vg1-home";
    varDisk = "/dev/mapper/vg1-var";
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  boot = {
    kernelParams = [
      "intel_iommu=on"
    ]
    ++ intelParams
    ++ params { };

    initrd = {
      availableKernelModules = [
        "i915"
        # "vfio_virqfd"
        # "vfio_pci"
        # "vfio_iommu_type1"
        # "vfi"
      ];
      kernelModules = [ "dm-snapshot" ];
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
