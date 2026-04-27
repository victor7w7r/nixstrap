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
      name = "bsystem.ssd1";
      size = "100%";
      priority = 10;
    };
  };

  lvs0 = {
    persist = (import ../lib/xfs.nix) {
      name = "persist";
      size = "100%";
      logdev = "/dev/mapper/persistlog";
    };
  };

  lvs1 = {
    storage = (import ../lib/xfs.nix) {
      name = "storage";
      size = "100%";
      logdev = "/dev/mapper/storagelog";
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

      #LUKS (enteramente sin GPT) -> bcache -> LVM -> XFS
      persist = {
        type = "disk";
        device = "${idpart}/ata-Micron_2400_MTFDKBK512QFM_232240F15D36";
        content = {
          type = "luks";
          content = {
            type = "lvm_pv";
            vg = "vg0";
          };
        };
      };

      storage = {
        type = "disk";
        device = "${idpart}/ata-Micron_2400_MTFDKBK512QFM_232240F15D36";
        content = {
          type = "luks";
          content = {
            type = "lvm_pv";
            vg = "vg1";
          };
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

    bcachefs_filesystems.broot = (import ../lib/bcachefs.nix).filesystem {
      subvolumes = {
        "subvolumes/nix".mountpoint = "/nix";
        "subvolumes/etc".mountpoint = "/nix/persist/etc";
      };
    };
  };
}
