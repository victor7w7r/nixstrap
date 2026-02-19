{ pkgs, ... }:
let
  intelParams = import ./lib/intel-params.nix;
  params = import ./lib/kernel-params.nix;
  boot = (import ./lib/boot.nix) {
    efiDisk = "emmc";
    emergencyDisk = "nvme";
  };
  zfs = import ./lib/zfs.nix;
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
    kernelPackages = pkgs.linuxPackages_6_12;
    zfs = {
      forceImportAll = false;
      forceImportRoot = true;
    };
    initrd = {
      availableKernelModules = [
        "i915"
        "autofs"
        "tpm-tis"
        "mmc_block"
        "sdhci_pci"
        "usb_storage"
        "uas"
        "uhci_hcd"
        "ehci_hcd"
        "xhci_pci"
        "usbcore"
        "sdhci_acpi"
        "sdhci"
      ];
      supportedFilesystems = [ "zfs" ];
      systemd = {
        services.zfs-import-setsecrets = {
          after = [ "media.mount" ];
          wantedBy = [ "initrd-fs.target" ];
          before = [ "initrd-fs.target" ];
          unitConfig.DefaultDependencies = false;
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          script = ''
            set -e

            mkdir -p /media
            mount -t btrfs -o nofail,noatime,lazytime,ssd,rw,x-initrd.mount \
                /dev/disk/by-id/usb-MXT-USB_Storage_Device_150101v01-0:0-part1 /media

            zpool import -f zcloud
            zpool import -f zswap
            zpool import -f zpersist

            cat /media/secret.key | zfs load-key zcloud/safe/cloud
            cat /media/secret.key | zfs load-key zswap/local/swap
            cat /media/secret.key | zfs load-key zpersist/safe/persist
          '';
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
