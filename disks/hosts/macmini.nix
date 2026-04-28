let
  winmod = import ../lib/windows.nix;

  macpartitions = {
    esp = (import ../lib/esp.nix) { };
    macos = {
      name = "macos";
      size = "110G";
      priority = 2;
    };
    root = (import ../lib/bcachefs.nix).partition {
      name = "broot.ssd1";
      size = "10G";
      priority = 3;
    };
    shared = (import ../lib/shared.nix) { };
  };

  ssdpartitions = {
    emergency = (import ../lib/emergency.nix) { priority = 1; };
    msr = winmod.msr { };
    recovery = winmod.recovery { priority = 3; };
    win = winmod.win { priority = 4; };
    swapcrypt = (import ../lib/luks.nix) {
      name = "swapcrypt";
      size = "64G";
      group = "ssd";
      content = (import ../lib/swap.nix) { };
      priority = 5;
    };
    persistlogcrypt = (import ../lib/luks.nix) {
      name = "persistlogcrypt";
      size = "512M";
      group = "ssd";
      priority = 6;
    };
    storagelogcrypt = (import ../lib/luks.nix) {
      name = "storagelogcrypt";
      size = "512M";
      group = "ssd";
      priority = 7;
    };
    persistcachecrypt = (import ../lib/luks.nix) {
      name = "persistcachecrypt";
      size = "90G";
      group = "ssd";
      priority = 8;
      postCreate = "make-bcache -C /dev/mapper/persistcache";
    };
    storagecachecrypt = (import ../lib/luks.nix) {
      name = "storagecachecrypt";
      size = "90G";
      group = "ssd";
      priority = 9;
      postCreate = "make-bcache -C /dev/mapper/storagecache";
    };
    system = (import ../lib/bcachefs.nix).partition {
      filesystem = "bsystem";
      name = "bsystem.ssd1";
      size = "100%";
      priority = 10;
    };
  };

  lvs0 = {
    persist = (import ../lib/xfs.nix) {
      name = "persist";
      size = "85%";
      mountpoint = "/nix/persist";
      logdev = "/dev/mapper/persistlogcrypt";
    };
  };

  lvs1 = {
    storage = (import ../lib/xfs.nix) {
      name = "storage";
      size = "85%";
      mountpoint = "/nix/persist/storage";
      logdev = "/dev/mapper/storagelogcrypt";
    };
  };

  partlabel = "/dev/disk/by-partlabel";
  idpart = "/dev/disk/by-id";
in
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = macpartitions;
        };
      };

      ssd = {
        type = "disk";
        device = "${idpart}/ata-Micron_2400_MTFDKBK512QFM_232240F15D36";
        content = {
          type = "gpt";
          partitions = ssdpartitions;
        };
      };

      persist = {
        type = "disk";
        device = "${idpart}/ata-WDC_WD5000LPSX-75A6WT0_WX12A21JEEPK";
        content = (import ../lib/luks.nix) {
          entireDisk = true;
          allowDiscards = false;
          name = "persist";
          size = "100%";
          group = "persist";
          postMount = ''
            cryptsetup open ${partlabel}/disk-ssd-persistcachecrypt persistcachecrypt --key-file /tmp/key.txt || true
            cryptsetup open ${partlabel}/disk-ssd-persistlogcrypt persistlogcrypt --key-file /tmp/key.txt || true
            echo /dev/mapper/persist | tee /sys/fs/bcache/register || true
          '';
          postCreate = ''
            make-bcache -B /dev/mapper/persist
            #CACHE_SET_UUID=$(sudo bcache-super-show /dev/disk/by-id/ata-Micron_2400_MTFDKBK512QFM_232240F15D36-part8 | grep 'cset.uuid' | awk '{print $2}')
            #echo $CACHE_SET_UUID > /sys/block/bcache0/bcache/attach
          '';
        };
      };

      storage = {
        type = "disk";
        device = "${idpart}/ata-ST500LT012-1DG142_S3PMCMHT";
        content = (import ../lib/luks.nix) {
          entireDisk = true;
          allowDiscards = false;
          name = "storage";
          size = "100%";
          group = "storage";
          postMount = ''
            cryptsetup open ${partlabel}/disk-ssd-storagecachecrypt storagecachecrypt --key-file /tmp/key.txt || true
            cryptsetup open ${partlabel}/disk-ssd-storagelogcrypt storagelogcrypt --key-file /tmp/key.txt || true
            echo /dev/mapper/persist | tee /sys/fs/bcache/register || true
          '';
          postCreate = ''
            make-bcache -B /dev/mapper/storage
            #CACHE_SET_UUID=$(sudo bcache-super-show /dev/disk/by-id/ata-Micron_2400_MTFDKBK512QFM_232240F15D36-part9 | grep 'cset.uuid' | awk '{print $2}')
            #echo $CACHE_SET_UUID > /sys/block/bcache1/bcache/attach
          '';
        };
      };

      bcache0 = {
        type = "disk";
        device = "/dev/bcache0";
        content = {
          vg = "vg0";
          type = "lvm_pv";
        };
      };

      bcache1 = {
        type = "disk";
        device = "/dev/bcache1";
        content = {
          vg = "vg1";
          type = "lvm_pv";
        };
      };
    };

    lvm_vg = {
      "vg0" = {
        type = "lvm_vg";
        lvs = lvs0;
      };
      "vg1" = {
        type = "lvm_vg";
        lvs = lvs1;
      };
    };

    bcachefs_filesystems = {
      bsystem = (import ../lib/bcachefs.nix).filesystem {
       # uuid = "73cb3bc2-8160-469c-bff2-a55d8f017b6d";
        subvolumes = {
          "subvolumes/nix".mountpoint = "/nix";
          "subvolumes/etc".mountpoint = "/nix/persist/etc";
        };
      };

      broot = (import ../lib/bcachefs.nix).filesystem {
        mountpoint = "/";
        subvolumes = { };
        uuid = "f9d26816-07f4-42cf-a9ae-f698ff56b172";
      };
    };
  };
}
