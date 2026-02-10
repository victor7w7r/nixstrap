let
  zfs = import ../lib/zfs.nix;

  mmcpartitions = {
    esp = (import ../lib/esp.nix) { };
    system = zfs.partition {
      size = "100G";
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
  };

  partlabel = "/dev/disk/by-partlabel";
  idpart = "/dev/disk/by-id";

  zroot = zfs.pool {
    isRoot = true;
    mode = "";
    datasets = zfs.volume {
      name = "swap";
      options = {
        volblocksize = "4096";
        compression = "zle";
        logbias = "throughput";
        encryption = "aes-256-gcm";
        keyformat = "passphrase";
        sync = "always";
        primarycache = "metadata";
        secondarycache = "none";
        "com.sun:auto-snapshot" = "false";
      };
      content = {
        type = "swap";
        discardPolicy = "both";
      };
    };
    /*
      zfs.dataset {
        isRoot = true;
        options = {
          canmount = "on";
          compression = "zstd";
        };
      }
      // zfs.dataset {
        name = "nix";
        mountpoint = "/nix";
        options = {
          canmount = "on";
          compression = "zstd";
          "com.sun:auto-snapshot" = "true";
        };
      }
      // zfs.dataset {
        name = "persist";
        mountpoint = "/nix/persist";
        options = {
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "prompt";
          "com.sun:auto-snapshot" = "true";
        };
      }
      // zfs.dataset {
        name = "vm";
        mountpoint = "/nix/persist/var/lib/libvirt/images";
        options = {
          recordsize = "64K";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "prompt";
          "com.sun:auto-snapshot" = "true";
        };
        };
    */
  };

  zcloud = zfs.pool {
    vdev = [
      {
        mode = "raidz1";
        members = [
          "${idpart}/ata-WDC_WD10SPZX-75Z10T1_WXB1A281J35X"
          "${idpart}/ata-MM1000GBKAL_9XG3YGXQ"
          "${idpart}/ata-WDC_WD10SPZX-24Z10_WD-WXU1E887FE3H"
          "${idpart}/ata-TOSHIBA_MQ01ABD100_46G8SH1BS"
        ];
      }
    ];
    log = [ { members = [ "${partlabel}/disk-nvme-cloudlog" ]; } ];
    special = [ { members = [ "${partlabel}/disk-nvme-cloudspecial" ]; } ];
    cache = [ "${partlabel}/disk-nvme-cloudcache" ];
    datasets = zfs.dataset {
      pool = "zcloud";
      name = "cloud";
      mountpoint = "/nix/persist/cloud";
      options = {
        encryption = "aes-256-gcm";
        keyformat = "passphrase";
        keylocation = "prompt";
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
        device = "/dev/mmcblk0";
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
        device = "ata-TOSHIBA_MQ01ABD100_46G8SH1BS";
      };
      sysroot = zfs.entireDisk {
        device = "ata-ST500LT012-1DG142_S3PMCMHT";
        pool = "zroot";
      };
    };
    zpool = { inherit zroot zcloud; };
  };
}
