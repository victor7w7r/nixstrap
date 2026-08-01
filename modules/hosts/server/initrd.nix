{
  den.aspects.server.initrd.nixos =
    { lib, pkgs, ... }:
    {
      boot.initrd = {
        supportedFilesystems = lib.mkAfter [ "xfs" ];
        kernelModules = [
          "btrfs"
          "br_netfilter"
          "bcache"
          "cryptd"
          "encrypted_keys"
          "aesni_intel"
          "dm_crypt"
          "dm_mod"
          "mmc_block"
          "nf_nat"
          "md_mod"
          "raid456"
          "fido2"
          "ahci"
          "usb_storage"
          "iptable_nat"
          "overlay"
          "uas"
          "uhci_hcd"
          "ehci_hcd"
          "xhci_pci"
          "r8168"
          "sdhci_acpi"
          "sdhci"
          "sdhci_pci"
          "tpm-tis"
          "usbcore"
          "zram"
        ];
        services.lvm.enable = true;
        systemd = {
          storePaths = [
            "${pkgs.btrfs-progs}/bin/btrfs"
            "${pkgs.util-linux}/bin/mount"
            "${pkgs.util-linux}/bin/umount"
            "${pkgs.coreutils}/bin/sleep"
            "${pkgs.systemd}/bin/udevadm"
          ];
          services.setup-storage-stack =
            let
              partlabel = "/dev/disk/by-partlabel";
              idpart = "/dev/disk/by-id";
              keydevice = "${idpart}/usb-MXT-USB_Storage_Device_150101v01-0:0-part1";
            in
            {
              wantedBy = [ "initrd.target" ];
              requiredBy = [ "sysroot.mount" ];
              requires = [ "dev-md-raid0.device" ];
              before = [
                "dev-vg0-cloud.device"
                "dev-mapper-persist.device"
                "initrd-fs.target"
                "sysroot.mount"
              ];
              after = [
                "systemd-modules-load.service"
                "dev-md-raid0.device"
              ];
              unitConfig.DefaultDependencies = false;
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
              };
              path = with pkgs; [
                util-linux
                cryptsetup
                systemd
                e2fsprogs
                coreutils
                lvm2
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

                 cryptsetup open ${partlabel}/disk-nvme-swapcrypt swapcrypt --key-file /media/secret.key
                 cryptsetup open ${partlabel}/disk-nvme-cloudcachecrypt cloudcachecrypt --key-file /media/secret.key
                 cryptsetup open ${partlabel}/disk-nvme-cloudlogcrypt cloudlogcrypt --key-file /media/secret.key
                 cryptsetup open ${partlabel}/disk-nvme-persist persist --key-file /media/secret.key

                 for i in {1..30}; do
                   if [ -e /dev/bcache0 ]; then
                      echo "Appear in attempt $i"
                      cryptsetup open /dev/bcache0 cloud --key-file /media/secret.key
                      udevadm trigger --action=add --subsystem-match=block
                      udevadm settle
                      lvm vgscan --mknodes
                      lvm vgchange -ay vg0
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
    };
}
