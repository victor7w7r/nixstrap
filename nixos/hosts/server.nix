{ pkgs, lib, ... }:
let
  intelParams = import ./lib/intel-params.nix;
  params = import ./lib/kernel-params.nix;
  boot = (import ./lib/boot.nix) { };
  zfs = import ./lib/zfs.nix;
  f2fs = import ./lib/f2fs.nix;
in
{
  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    "/" = zfs { preDataset = "local"; };
    "/nix" = f2fs { label = "store"; };
    "/nix/persist" = zfs {
      pool = "zpersist";
      dataset = "persist";
    };
    "/nix/persist/shared" = f2fs {
      label = "store";
      neededForBoot = false;
    };
    "/nix/persist/cloud" = zfs {
      pool = "zcloud";
      dataset = "cloud";
      neededForBoot = false;
    };
  };

  swapDevices = [ { device = "/dev/zvol/zswap/local/swap"; } ];
  boot = {
    kernelParams = [ "intel_iommu=on" ] ++ intelParams ++ params { };
    kernelPackages = pkgs.linuxPackages_6_12;
    zfs = {
      allowHibernation = true;
      forceImportAll = false;
      forceImportRoot = false;
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
      kernelModules = [ "" ];
      systemd = with lib; {
        services.zfs-import-rpool.script = mkForce ''
          mkdir -p /media
          mount -t btrfs /dev/disk/by-id/usb-MXT-USB_Storage_Device_150101v01-0:0-part1 /media

          zpool status zcloud || zpool import -f zcloud
          zpool status zswap || zpool import -f zswap
          zpool status zpersist || zpool import -f zpersist

          cat /media/secret.key | sudo zfs load-key zcloud/safe/cloud
          cat /media/secret.key | sudo zfs load-key zswap/local/swap
          cat /media/secret.key | sudo zfs load-key zpersist/safe/persist
        '';
      };
    };
  };

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "Sat, 02:00";
      pools = [
        "zroot"
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
