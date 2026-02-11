let
  zfs = import ../lib/zfs.nix;

  mmcpartitions = {
    esp = (import ../lib/esp.nix) { };
    system = zfs.partition {
      size = "90G";
      priority = 2;
    };
    shared = zfs.partition {
      size = "100%";
      pool = "zshared";
      priority = 3;
    };
  };

  nvmepartitions = {
    emergency = (import ../lib/emergency.nix) { priority = 1; };
    swap = zfs.partition {
      size = "8G";
      pool = "zswap";
      priority = 2;
    };
    cloudlog = zfs.partition {
      size = "16G";
      pool = "zcloud";
      priority = 3;
    };
    cloudspecial = zfs.partition {
      size = "50G";
      pool = "zcloud";
      priority = 4;
    };
    cloudcache = zfs.partition {
      size = "100G";
      pool = "zcloud";
      priority = 5;
    };
    persist = zfs.partition {
      size = "100%";
      pool = "zpersist";
      priority = 6;
    };
  };

  partlabel = "/dev/disk/by-partlabel";
  idpart = "/dev/disk/by-id";

  zroot = zfs.pool {
    isRoot = true;
    mode = "";
    postCreateHook = ''
      mkfs.f2fs -f -O \
        extra_attr,inode_checksum,flexible_inline_xattr,lost_found,sb_checksum \
        -l z-system /dev/zvol/zroot/safe/root/system
    '';
    datasets =
      zfs.preDataset { }
      // zfs.volume {
        name = "system";
        preDataset = "safe";
        size = "70G";
        options.compression = "lz4";
        /*
          content = {
          type = "filesystem";
          format = "f2fs";
          mountpoint = "/nix";
          #mountOptions = f2fs-args { name = "system"; }.mountOptions;
          };
        */
      }
      // zfs.volume {
        name = "root";
        size = "60G";
        preDataset = "safe";
        options.compression = "lz4";
        /*
          content = {
          type = "filesystem";
          format = "f2fs";
          mountpoint = "/";
          #mountOptions = f2fs-args { name = "root"; }.mountOptions;
          };
        */
      }
      // zfs.preDataset { name = "safe"; };
  };

  zcloud = zfs.pool {
    vdev = [
      {
        mode = "raidz1";
        members = [
          "${idpart}/ata-MM1000GBKAL_9XG3YGXQ"
          "${idpart}/ata-WDC_WD10EZEX-60ZF5A0_WD-WMC1S2944154"
          "${idpart}/ata-WDC_WD10SPZX-24Z10_WD-WXU1E887FE3H"
          "${idpart}/ata-WDC_WD10SPZX-75Z10T1_WXB1A281J35X"
          "${idpart}/ata-TOSHIBA_DT01ACA100_Y7JAA68MS"
        ];
      }
    ];
    log = [ { members = [ "${partlabel}/disk-nvme-cloudlog" ]; } ];
    special = [ { members = [ "${partlabel}/disk-nvme-cloudspecial" ]; } ];
    cache = [ "${partlabel}/disk-nvme-cloudcache" ];
    datasets =
      zfs.preDataset { name = "safe"; }
      // zfs.dataset {
        pool = "zcloud";
        name = "cloud";
        preDataset = "safe";
        mountpoint = "/nix/persist/cloud";
        options = {
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "file:///mnt/secret.key";
          "com.sun:auto-snapshot" = "true";
        };
      };
  };
  zswap = zfs.pool {
    mode = "";
    datasets =
      zfs.preDataset { }
      // zfs.volume {
        name = "swap";
        size = "8G";
        options = {
          compression = "zle";
          logbias = "throughput";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          sync = "always";
          primarycache = "metadata";
          secondarycache = "none";
        };
        content = {
          type = "swap";
          discardPolicy = "both";
        };
      };
  };
  zpersist = zfs.pool {
    mode = "";
    datasets =
      zfs.preDataset { name = "safe"; }
      // zfs.dataset {
        pool = "zpersist";
        name = "persist";
        mountpoint = "/nix/persist";
        preDataset = "safe";
        options = {
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "file:///mnt/secret.key";
          "com.sun:auto-snapshot" = "true";
        };
      };
  };
  zshared = zfs.pool {
    mode = "";
    datasets =
      zfs.preDataset { name = "safe"; }
      // zfs.dataset {
        pool = "zshared";
        preDataset = "safe";
        name = "shared";
        mountpoint = "/nix/persist/shared";
      };
  };
in
{
  disko.devices = {
    disk = {
      emmc = {
        type = "disk";
        device = "/dev/disk/by-id/mmc-SCA256_0x3870d703";
        content = {
          type = "gpt";
          partitions = mmcpartitions;
        };
      };
      nvme = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = nvmepartitions;
        };
      };
      cloud1 = zfs.entireDisk {
        device = "ata-WDC_WD10SPZX-75Z10T1_WXB1A281J35X";
      };
      cloud2 = zfs.entireDisk {
        device = "ata-MM1000GBKAL_9XG3YGXQ";
      };
      cloud3 = zfs.entireDisk {
        device = "ata-WDC_WD10SPZX-24Z10_WD-WXU1E887FE3H";
      };
      cloud4 = zfs.entireDisk {
        device = "ata-WDC_WD10EZEX-60ZF5A0_WD-WMC1S2944154";
      };
      cloud5 = zfs.entireDisk {
        device = "ata-TOSHIBA_DT01ACA100_Y7JAA68MS";
      };
    };
    zpool = {
      inherit
        zroot
        zcloud
        zswap
        zpersist
        zshared
        ;
    };
  };
}
