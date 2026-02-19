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
        "btrfs"
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
      systemd = {
        storePaths = [
          "${pkgs.btrfs-progs}/bin/btrfs"
          "${pkgs.util-linux}/bin/mount"
          "${pkgs.util-linux}/bin/umount"
          "${pkgs.coreutils}/bin/sleep"
          "${pkgs.systemd}/bin/udevadm"
        ];
        services = {
          zfs-import-zroot.enable = false;
          zfs-import-zcloud.enable = false;
          zfs-import-zswap.enable = false;
          zfs-import-zpersist.enable = false;

          zfs-setimport = {
            wantedBy = [ "initrd.target" ];
            before = [
              "rollback-zfs.service"
              "initrd-fs.target"
              "sysroot.mount"
            ];
            after = [
              "systemd-modules-load.service"
            ];
            unitConfig.DefaultDependencies = false;
            path = [
              config.boot.zfs.package
              pkgs.util-linux
              pkgs.systemd
              pkgs.coreutils
            ];
            script = ''
              set -e
              mkdir -p /media
              DEVICE="/dev/disk/by-id/usb-MXT-USB_Storage_Device_150101v01-0:0-part1"

              for i in {1..30}; do
                if [ ! -e "$DEVICE" ]; then
                    udevadm trigger --action=add --subsystem-match=block
                    udevadm settle --timeout=1
                fi
                if [ -e "$DEVICE" ]; then
                    echo "Appear in attempt $i"
                    if mount -t btrfs -o rw,noatime,ssd,discard=async "$DEVICE" /media; then
                        break
                    fi
                fi
                echo "Waiting SCSI/USB... ($i/30)"
                sleep 1
                done

              zpool import -f -N -a -d /dev/disk/by-id
              zfs rollback -r zroot/local/root@empty
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
