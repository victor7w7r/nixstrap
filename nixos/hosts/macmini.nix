{
  inputs,
  host,
  config,
  kernelData,
  lib,
  pkgs,
  ...
}:
let
  intelParams = import ./lib/intel-params.nix;
  helpers = pkgs.callPackage "${inputs.nix-cachyos-kernel.outPath}/helpers.nix" { };
  kernelBuild = (pkgs.callPackage ../kernel) {
    inherit
      helpers
      host
      kernelData
      inputs
      ;
  };
  params = import ./lib/params.nix;
  boot = (import ./lib/boot.nix) {
    emergencyDisk = "ssd";
  };
  btrfs = (import ./lib/btrfs.nix);
  zfs = import ./lib/zfs.nix;
in
{

  nixpkgs.overlays = [
    (_final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    "/" = zfs { preDataset = "local"; };
    "/nix" = zfs { dataset = "zsys"; };
    "/nix/persist" = zfs { dataset = "zsys"; };
    "/nix/persist/storage" = zfs {
      pool = "zdata";
      dataset = "storage";
    };
    "/nix/persist/etc" = zfs {
      pool = "zetc";
      dataset = "etc";
    };
    "/nix/persist/shared" = zfs {
      pool = "zshared";
      dataset = "shared";
    };
    "/nix/persist/ssdshared" = zfs {
      pool = "zssdshared";
      dataset = "ssdshared";
    };
  };
  swapDevices = [
    {
      device = "/dev/zd0";
      discardPolicy = "both";
      options = [ "nofail" ];
    }
  ];
  boot = {
    kernelParams = [ "intel_iommu=on" ] ++ intelParams ++ params { };
    kernelPackages = (lib.mkForce helpers.kernelModuleLLVMOverride (kernelBuild.packages)).extend (
      _self: _super: {
        kernel_configfile = _super.kernel.configfile;
        zfs_cachyos = pkgs.cachyosKernels.zfs-cachyos-lto.override { kernel = kernelBuild.kernel; };
      }
    );

    zfs = {
      package = config.boot.kernelPackages.zfs_cachyos;
      forceImportAll = false;
      forceImportRoot = true;
    };
    initrd = {
      availableKernelModules = [
        "zfs"
        "btrfs"
        "usb_storage"
        "usb_storage"
        "usbcore"
        # "vfio_virqfd"
        # "vfio_pci"
        # "vfio_iommu_type1"
        # "vfi"
      ];
    };

  };

  environment.systemPackages = with pkgs; [
    bolt
    tbtools
    thunderbolt
    kdePackages.plasma-thunderbolt
  ];

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "Sat, 02:00";
      pools = [
        "zsys"
        "zdata"
        "zetc"
        "zssdshared"
        "zshared"
      ];
    };
    autoSnapshot = {
      enable = true;
      frequent = 4;
      hourly = 24;
      daily = 7;
      weekly = 4;
      monthly = 12;
      flags = "-k -p";
    };
    trim.enable = true;
    trim.interval = "weekly";
  };

}
