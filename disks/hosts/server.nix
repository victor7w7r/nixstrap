let
  zfs = import ../lib/zfs.nix;

  mmcpartitions = {
    esp = (import ../lib/esp.nix) { };
    store = (import ../lib/f2fs.nix) {
      name = "store";
      size = "70G";
      mountpoint = "/nix";
      priority = 2;
    };
    shared = (import ../lib/f2fs.nix) {
      name = "shared";
      size = "100%";
      mountpoint = "/nix/persist/shared";
      priority = 3;
    };
  };

  nvmepartitions = {
    emergency = (import ../lib/emergency.nix) { priority = 1; };
    swap = zfs.partition {
      size = "11G";
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
    root = zfs.partition {
      size = "30G";
      pool = "zroot";
      priority = 6;
    };
    persist = zfs.partition {
      size = "100%";
      pool = "zpersist";
    };
  };

  partlabel = "/dev/disk/by-partlabel";
  idpart = "/dev/disk/by-id";

  zroot = zfs.pool {
    isRoot = true;
    mode = "";
    datasets =
      zfs.preDataset { name = "local"; }
      // zfs.dataset {
        preDataset = "local";
        options = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
      };
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
      zfs.preDataset { }
      // zfs.dataset {
        pool = "zcloud";
        name = "cloud";
        mountpoint = "/nix/persist/cloud";
        options = {
          compression = "zstd";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "file:///tmp/secret.key";
          "com.sun:auto-snapshot" = "true";
        };
      };
  };
  zswap = zfs.pool {
    mode = "";
    datasets =
      zfs.preDataset { name = "local"; }
      // zfs.volume {
        name = "swap";
        preDataset = ''local'';
        size = "8G";
        options = {
          compression = "zle";
          logbias = "throughput";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "file:///tmp/secret.key";
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
      zfs.preDataset { }
      // zfs.dataset {
        pool = "zpersist";
        name = "persist";
        mountpoint = "/nix/persist";
        options = {
          compression = "zstd";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "file:///tmp/secret.key";
          "com.sun:auto-snapshot" = "true";
        };
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
        zpersist
        zswap
        zcloud
        zroot
        ;
    };
  };
}
