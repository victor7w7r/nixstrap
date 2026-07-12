{
  den.aspects.main.initrd.nixos =
    { lib, pkgs, ... }:
    {
      boot.initrd = {
        supportedFilesystems = lib.mkAfter [
          "bcachefs"
          "xfs"
        ];
        kernelModules = [
          "apple-bce"
          "aes_ni"
          "brcmfmac_wcc"
          "brcmfmac"
          "btrfs"
          "cryptd"
          "dm_crypt"
          "dm_mod"
          "bcache"
          "uas"
          "usb_storage"
          "ahci"
          "usbhid"
          "sd_mod"
          "uhci_hcd"
          "ehci_hcd"
          "xhci_pci"
          "usbcore"
          "zram"
          # "vfio_virqfd"
          # "vfio_pci"
          # "vfio_iommu_type1"
          # "vfi"
        ];
        systemd.services.setup-storage =
          let
            partlabel = "/dev/disk/by-partlabel";
            idpart = "/dev/disk/by-id";
            keydevice = "${idpart}/usb-Generic_Mass-Storage_20240418000000-0:0-part1";
          in
          {
            wantedBy = [ "initrd.target" ];
            requiredBy = [ "sysroot.mount" ];
            before = [
              "dev-mapper-persist.device"
              "dev-mapper-storage.device"
              "initrd-fs.target"
              "sysroot.mount"
            ];
            after = [ "systemd-modules-load.service" ];
            unitConfig.DefaultDependencies = false;
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            path = with pkgs; [
              bcachefs-tools
              cryptsetup
              coreutils
              e2fsprogs
              lvm2
              systemd
              util-linux
            ];
            script = ''
              set -e
              mkdir -p /media

              echo 4G > /sys/block/zram1/disksize
              mkfs.ext4 -m 0 -O "^has_journal,^huge_file,^flex_bg" /dev/zram1

              for i in {1..10}; do
                if [ -e "${keydevice}" ]; then
                    echo "Appear in attempt $i"
                    if mount -t btrfs -o ro,noatime,ssd,discard=async "${keydevice}" /media; then
                        echo "Found key device"
                        break
                    fi
                fi
                echo "Waiting key device... ($i/10)"
                udevadm settle --timeout=2 || true && udevadm trigger --action=add --subsystem-match=block
                sleep 1
               done

               cryptsetup open ${idpart}/ata-WDC_WD5000LPSX-75A6WT0_WX12A21JEEPK persist --key-file /media/secret.key
               cryptsetup open ${idpart}/ata-ST500LT012-1DG142_S3PMCMHT storage --key-file /media/secret.key
               cryptsetup open ${partlabel}/disk-ssd-swapcrypt swapcrypt --key-file /media/secret.key
               cryptsetup open ${partlabel}/disk-ssd-persistcachecrypt persistcachecrypt --key-file /media/secret.key
               cryptsetup open ${partlabel}/disk-ssd-persistlogcrypt persistlogcrypt --key-file /media/secret.key
               cryptsetup open ${partlabel}/disk-ssd-storagecachecrypt storagecachecrypt --key-file /media/secret.key
               cryptsetup open ${partlabel}/disk-ssd-storagelogcrypt storagelogcrypt --key-file /media/secret.key

               for i in {1..30}; do
                 if [ -e /dev/bcache0 ] && [ -e /dev/bcache1 ] && [ -e /dev/mapper/persist ]  && [ -e /dev/mapper/storage ]; then
                    echo "Appear in attempt $i"
                    udevadm trigger --action=add --subsystem-match=block
                    udevadm settle
                    lvm vgscan --mknodes
                    lvm vgchange -ay vg0
                    lvm vgchange -ay vg1
                    break
                 fi
                 echo "Waiting persist and storage devices... ($i/30)"
                 udevadm settle --timeout=3 || true && udevadm trigger --action=add --subsystem-match=block
                 sleep 1
                done
            '';
          };
      };
    };
}
