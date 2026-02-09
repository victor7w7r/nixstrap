let
  zfs = import ../lib/zfs.nix;

  mmcpartitions = {
    esp = (import ../lib/esp.nix) { };
    sysetc = (import ../lib/f2fs.nix) {
      label = "sysetc";
      name = "sysetc";
      size = "2G";
      mountpoint = "/nix/persist/etc";
      isIsolated = true;
      priority = 2;
    };
    shared = (import ../lib/f2fs.nix) {
      label = "shared";
      name = "shared";
      size = "100%";
      mountpoint = "/nix/persist/shared";
      isIsolated = true;
      priority = 3;
    };
  };

  nvmepartitions = {
    emergency = (import ../filesystems/emergency.nix) { priority = 1; };
    swapcrypt = {
      name = "swapcrypt";
      size = "8G";
      priority = 2;
      content = {
        type = "swap";
        randomEncryption = true;
      };
    };
    syslog = zfs.partition {
      size = "2G";
      priority = 3;
    };
    cloudlog = zfs.partition {
      size = "16G";
      pool = "zcloud";
      priority = 4;
    };
    sysspecial = zfs.partition {
      size = "40G";
      priority = 5;
    };
    cloudspecial = zfs.partition {
      size = "100G";
      pool = "zcloud";
      priority = 6;
    };
    syscache = zfs.partition {
      size = "78G";
      priority = 7;
    };
    cloudcache = zfs.partition {
      priority = 8;
      size = "120G";
      pool = "zcloud";
    };
  };

  partlabel = "/dev/disk/by-partlabel";
  idpart = "/dev/disk/by-id";

  zroot = zfs.pool {
    isRoot = true;
    vdev = [ { members = [ "${idpart}/ata-ST500LT012-1DG142_S3PMCMHT" ]; } ];
    log = [ { members = [ "${partlabel}/disk-nvme-syslog" ]; } ];
    special = [ { members = [ "${partlabel}/disk-nvme-sysspecial" ]; } ];
    cache = [ "${partlabel}/disk-nvme-syscache" ];
    datasets =
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
