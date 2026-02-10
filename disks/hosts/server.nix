let
  zfs = import ../lib/zfs.nix;
  f2fs-args = import ../lib/f2fs-args.nix;

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

  zroot =
    let
      options = {
        volblocksize = "4096";
        compression = "lz4";
        "com.sun:auto-snapshot" = "false";
      };
    in
    zfs.pool {
      isRoot = true;
      mode = "";
      datasets =
        zfs.volume {
          name = "system";
          size = "70G";
          inherit options;
          content = {
            type = "filesystem";
            format = "f2fs";
            mountpoint = "/nix";
            mountOptions = f2fs-args { name = "system"; }.mountOptions;
            extraArgs = f2fs-args { name = "system"; }.extraArgs;
          };
        }
        // zfs.volume {
          name = "root";
          size = "100%";
          inherit options;
          content = {
            type = "filesystem";
            format = "f2fs";
            mountpoint = "/";
            mountOptions = f2fs-args { name = "root"; }.mountOptions;
            extraArgs = f2fs-args { name = "root"; }.extraArgs;
          };
        };
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
  zswap = zfs.pool {
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
  };
  zpersist = zfs.pool {
    mode = "";
    datasets = zfs.dataset {
      pool = "zpersist";
      name = "persist";
      mountpoint = "/nix/persist";
      options = {
        encryption = "aes-256-gcm";
        keyformat = "passphrase";
        keylocation = "prompt";
        "com.sun:auto-snapshot" = "true";
      };
    };
  };
  zshared = zfs.pool {
    mode = "";
    datasets = zfs.dataset {
      pool = "zshared";
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
      cloud5 = zfs.entireDisk {
        device = "ata-ST500LT012-1DG142_S3PMCMHT";
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
