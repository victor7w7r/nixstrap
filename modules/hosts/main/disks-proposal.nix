{ disko, ... }:
{
  den.aspects.main.disks-proposal.nixos = {
    fileSystems."/nix/persist".neededForBoot = true;
    disko.devices = with disko; {
      disk = {
        root = ephemeral.root { };
        bcache0 = disk.bcache { };
        main = disk.gpt {
          device = "nvme0n1";
          partitions = {
            esp = esp.call { };
            macos = {
              name = "macos";
              size = "110G";
              priority = 2;
            };
            system = btrfs.call {
              name = "system";
              size = "200G";
              subvolumes = btrfs.subvolumes {
                hasEtc = true;
                hasPersist = false;
              };
            };
            shared = btrfs.shared { };
          };
        };
        ssd = disk.gpt {
          device = "${disk.constants.id}/ata-Micron_2400_MTFDKBK512QFM_232240F15D36";
          partitions = {
            emergency = btrfs.emergency { priority = 1; };
            msr = win.msr { };
            recovery = win.recovery { priority = 3; };
            win = win.call { priority = 4; };
            swapcrypt = luks.call {
              name = "swapcrypt";
              device = "${disk.constants.partlabel}/disk-ssd-swapcrypt";
              size = "64G";
              content = swap.call { };
              priority = 5;
            };
            persistcachecrypt = luks.call {
              name = "persistcachecrypt";
              device = "${disk.constants.partlabel}/disk-ssd-persistcachecrypt";
              size = "120G";
              priority = 6;
              postCreate = "make-bcache -C /dev/mapper/persistcachecrypt";
            };
            shared = btrfs.shared { name = "ssdshared"; };
          };
        };
        persist = luks.entire {
          name = "persist";
          device = "/dev/${disk.constants.id}/ata-WDC_WD5000LPSX-75A6WT0_WX12A21JEEPK";
          postMount = ''
            echo /dev/mapper/persist | tee /sys/fs/bcache/register || true
          '';
          postCreate = ''
            make-bcache -B /dev/mapper/persist
            #CACHE_SET_UUID=$(sudo bcache-super-show /dev/disk/by-id/ata-Micron_2400_MTFDKBK512QFM_232240F15D36-part8 | grep 'cset.uuid' | awk '{print $2}')
            #echo $CACHE_SET_UUID > /sys/block/bcache0/bcache/attach
          '';
        };
        storage = luks.entire {
          name = "storage";
          device = "/dev/${disk.constants.id}/ata-ST500LT012-1DG142_S3PMCMHT";
        };
      };
      lvm_vg =
        (disk.vg {
          lvs = {
            persist = disko.xfs.call {
              name = "persist";
              size = "85%";
              mountpoint = "/nix/persist";
            };
          };
        })
        // (disk.vg {
          num = 1;
          lvs = {
            storage = disko.xfs.call {
              name = "storage";
              size = "85%";
              mountpoint = "/nix/storage";
            };
          };
        });
    };
  };
}
