{ disko, ... }:
{
  den.aspects.main.disks.nixos.disko.devices = with disko; {
    disk = {
      root = ephemeral.root { };
      main = disk.gpt {
        device = "nvme0n1";
        partitions = {
          esp = esp.call { };
          macos = {
            name = "macos";
            size = "110G";
            priority = 2;
          };
          root = bcachefs.partition {
            name = "broot.ssd1";
            size = "10G";
            priority = 3;
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
          persistlogcrypt = luks.call {
            name = "persistlogcrypt";
            device = "${disk.constants.partlabel}/disk-ssd-persistlogcrypt";
            size = "512M";
            priority = 6;
          };
          storagelogcrypt = luks.call {
            name = "storagelogcrypt";
            device = "${disk.constants.partlabel}/disk-ssd-storagelogcrypt";
            size = "512M";
            priority = 7;
          };
          persistcachecrypt = luks.call {
            name = "persistcachecrypt";
            device = "${disk.constants.partlabel}/disk-ssd-persistcachecrypt";
            size = "90G";
            priority = 8;
            postCreate = "make-bcache -C /dev/mapper/persistcachecrypt";
          };
          storagecachecrypt = luks.call {
            name = "storagecachecrypt";
            device = "${disk.constants.partlabel}/disk-ssd-storagecachecrypt";
            size = "90G";
            priority = 9;
            postCreate = "make-bcache -C /dev/mapper/storagecachecrypt";
          };
          system = bcachefs.partition {
            filesystem = "bsystem";
            name = "bsystem.ssd1";
            size = "100%";
            priority = 10;
          };
        };
      };
      bcache0 = disk.bcache-lvm { };
      bcache1 = disk.bcache-lvm { num = 1; };
      persist = disk.entire-luks {
        name = "persist";
        device = "${disk.constants.id}/ata-WDC_WD5000LPSX-75A6WT0_WX12A21JEEPK";
        postMount = ''
          cryptsetup open ${disk.constants.partlabel}/disk-ssd-persistcachecrypt persistcachecrypt --key-file /tmp/key.txt || true
          cryptsetup open ${disk.constants.partlabel}/disk-ssd-persistlogcrypt persistlogcrypt --key-file /tmp/key.txt || true
          echo /dev/mapper/persist | tee /sys/fs/bcache/register || true
        '';
        postCreate = ''
          make-bcache -B /dev/mapper/persist
          #CACHE_SET_UUID=$(sudo bcache-super-show /dev/disk/by-id/ata-Micron_2400_MTFDKBK512QFM_232240F15D36-part8 | grep 'cset.uuid' | awk '{print $2}')
          #echo $CACHE_SET_UUID > /sys/block/bcache0/bcache/attach
        '';
      };
      storage = disk.entire-luks {
        name = "storage";
        device = "${disk.constants.id}/ata-ST500LT012-1DG142_S3PMCMHT";
        postMount = ''
          cryptsetup open ${disk.constants.partlabel}/disk-ssd-storagecachecrypt storagecachecrypt --key-file /tmp/key.txt || true
          cryptsetup open ${disk.constants.partlabel}/disk-ssd-storagelogcrypt storagelogcrypt --key-file /tmp/key.txt || true
          echo /dev/mapper/storage | tee /sys/fs/bcache/register || true
        '';
        postCreate = ''
          make-bcache -B /dev/mapper/storage
          #CACHE_SET_UUID=$(sudo bcache-super-show /dev/disk/by-id/ata-Micron_2400_MTFDKBK512QFM_232240F15D36-part9 | grep 'cset.uuid' | awk '{print $2}')
          #echo $CACHE_SET_UUID > /sys/block/bcache1/bcache/attach
        '';
      };
    };
    lvm_vg =
      (disk.vg {
        lvs = {
          persist = disko.xfs.call {
            name = "persist";
            size = "85%";
            mountpoint = "/nix/persist";
            logdev = "/dev/mapper/persistlogcrypt";
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
            logdev = "/dev/mapper/storagelogcrypt";
          };
        };
      });
    bcachefs_filesystems.bsystem = bcachefs.filesystem {
      uuid = "66684a8a-b6ef-45ac-9e24-9ee3a2b4b540";
      subvolumes =
        (bcachefs.subvolume {
          name = "nix";
          mountpoint = "/nix";
        })
        // (bcachefs.subvolume {
          name = "etc";
          mountpoint = "/nix/persist/etc";
        });
    };
  };
}
