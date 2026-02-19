{
  config,
  utils,
  pkgs,
  ...
}:
let
  intelParams = import ./lib/intel-params.nix;
  params = import ./lib/kernel-params.nix;
  boot = (import ./lib/boot.nix) {
    efiDisk = "emmc";
    emergencyDisk = "nvme";
  };
  zfs = import ./lib/zfs.nix;
  btrfs = import ./lib/btrfs.nix;
  f2fs = import ./lib/f2fs.nix;
in
{
  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    "/" = zfs { preDataset = "local"; };
    "/nix" = f2fs {
      label = "store";
      depends = [ "/" ];
    };
    "/media" = btrfs {
      hasSubvol = false;
      device = "/dev/disk/by-id/usb-MXT-USB_Storage_Device_150101v01-0:0-part1";
    };
    "/nix/persist" = zfs {
      pool = "zpersist";
      dataset = "persist";
      depends = [ "/nix" ];
    };
    "/nix/persist/shared" = f2fs {
      label = "shared";
      neededForBoot = false;
      depends = [ "/nix/persist" ];
    };
    "/nix/persist/cloud" = zfs {
      pool = "zcloud";
      dataset = "cloud";
      neededForBoot = false;
      depends = [ "/nix/persist" ];
    };
  };

  /*
    swapDevices = [
    {
      device = "/dev/zvol/zswap/local/swap";
      discardPolicy = "both";
      options = [ "nofail" ];
    }
    ];
  */
  boot = {
    kernelParams = [ "intel_iommu=on" ] ++ intelParams ++ params { };
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-server-lto;
    zfs = {
      package = config.boot.kernelPackages.zfs_cachyos;
      forceImportAll = false;
      forceImportRoot = true;
    };
    initrd = {
      availableKernelModules = [ "i915" ];
      kernelModules = [
        "mmc_block"
        "zfs"
        "autofs"
        "sdhci_pci"
        "usb_storage"
        "uas"
        "uhci_hcd"
        "ehci_hcd"
        "xhci_pci"
        "usbcore"
        "sdhci_acpi"
        "sdhci"
        "tpm-tis"
      ];
      supportedFilesystems = [ "zfs" ];
      systemd.services = {
        zfs-import-zroot.enable = false;
        zfs-import-zcloud.enable = false;
        zfs-import-zswap.enable = false;
        zfs-import-zpersist.enable = false;

        zfs-setimport =
          let
            disk = "${utils.escapeSystemdPath "/dev/disk/by-id/usb-MXT-USB_Storage_Device_150101v01-0:0-part1"}.device";
          in
          {
            wantedBy = [ "initrd-fs.target" ];
            before = [
              "zfs-load-key.service"
              "rollback-zfs.service"
              "sysroot.mount"
              "initrd-fs.target"
            ];
            after = [ disk ];
            bindsTo = [ disk ];
            unitConfig.DefaultDependencies = false;
            path = [ config.boot.zfs.package ];
            script = "zpool import -f -N -a -d /dev/disk/by-id";
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
          };

        zfs-load-key = {
          requiredBy = [ "initrd-fs.target" ];
          after = [ "zfs-setimport.service" ];
          before = [
            "rollback-zfs.service"
            "initrd-fs.target"
            "sysroot.mount"
          ];
          path = [ config.boot.zfs.package ];
          unitConfig = {
            RequiresMountsFor = "/media";
            DefaultDependencies = false;
          };
          script = ''
            cat /media/secret.key | zfs load-key zswap/local/swap
            cat /media/secret.key | zfs load-key zpersist/safe/persist
            cat /media/secret.key | zfs load-key zcloud/safe/cloud
          '';
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
        };

      };
    };
  };

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "Sat, 02:00";
      pools = [
        "zpersist"
        "zcloud"
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

  #hardware.intel-gpu-tools = true;
}
